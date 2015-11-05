class StopWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def wait_for_action(phoenix, action_id)
    while phoenix.action_status(action_id) != "completed"
      sleep 30
    end
  end

  def perform(phoenix_id)
    phoenix = Phoenix.find(phoenix_id)
    return unless phoenix.on?

    # Update status for being shut down
    phoenix.update!(status: "Burning")

    # Power down the server
    shutdown_action = phoenix.shutdown
    wait_for_action(phoenix, shutdown_action.id) if shutdown_action

    # Snapshot the server
    snapshot_action = phoenix.snapshot
    wait_for_action(phoenix, snapshot_action.id) if snapshot_action

    # Update image ID
    phoenix.update!(image_id: phoenix.snapshot_ids.last)

    # Destroy the server
    phoenix.burn!

    # Defer to default status
    phoenix.update!(status: nil)
  rescue Exception => e
    puts "Stop failed"
    puts e.message
    puts e.backtrace.inspect

    phoenix.update!(status: "Failed to burn")
  end
end
