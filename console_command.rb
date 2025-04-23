NotificationService.notify(User.first, type: :info, title: "Test Notification", body: "This is a test notification sent at #{Time.current.strftime('%H:%M:%S')}", data: { test: true })
