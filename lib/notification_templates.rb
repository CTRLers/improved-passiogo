module NotificationTemplates
  # Template storage - this could be moved to a database table in a production app
  @templates = {}

  # List of available templates
  def self.list
    puts "\n📋 Available Notification Templates:"

    if @templates.empty?
      puts "No templates found. Create one with NotificationTemplates.create"
      return []
    end

    puts "-" * 80
    puts "| %-20s | %-15s | %-40s |" % [ "Name", "Type", "Title" ]
    puts "-" * 80

    @templates.each do |name, template|
      puts "| %-20s | %-15s | %-40s |" % [
        name,
        template[:type].to_s,
        template[:title].truncate(40)
      ]
    end

    puts "-" * 80
    @templates.keys
  end

  # Create a new template
  def self.create(name, type: :info, title:, body:, data: {})
    if @templates[name.to_s]
      puts "Template '#{name}' already exists. Use update to modify it."
      return false
    end

    @templates[name.to_s] = {
      type: type.to_sym,
      title: title,
      body: body,
      data: data
    }

    puts "\n✓ Created template '#{name}'"
    true
  end

  # Update an existing template
  def self.update(name, type: nil, title: nil, body: nil, data: nil)
    template = @templates[name.to_s]

    unless template
      puts "Template '#{name}' not found"
      return false
    end

    template[:type] = type.to_sym if type
    template[:title] = title if title
    template[:body] = body if body
    template[:data] = data if data

    puts "\n✓ Updated template '#{name}'"
    true
  end

  # Delete a template
  def self.delete(name)
    if @templates.delete(name.to_s)
      puts "\n✓ Deleted template '#{name}'"
      true
    else
      puts "Template '#{name}' not found"
      false
    end
  end

  # View a template
  def self.view(name)
    template = @templates[name.to_s]

    unless template
      puts "Template '#{name}' not found"
      return nil
    end

    puts "\n📝 Template: #{name}"
    puts "=" * 50
    puts "Type:  #{template[:type]}"
    puts "Title: #{template[:title]}"
    puts "Body:  #{template[:body]}"
    puts "Data:  #{template[:data].inspect}"

    template
  end

  # Use a template to send a notification
  def self.use(name, recipients, data_replacements: {})
    template = @templates[name.to_s]

    unless template
      puts "Template '#{name}' not found"
      return false
    end

    # Apply any data replacements to the template
    title = template[:title].dup
    body = template[:body].dup

    # Replace placeholders in title and body
    data_replacements.each do |key, value|
      placeholder = "%{#{key}}"
      title.gsub!(placeholder, value.to_s)
      body.gsub!(placeholder, value.to_s)
    end

    # Merge template data with replacements
    data = template[:data].merge(data_replacements)

    # Send notification based on recipient type
    case recipients
    when Integer
      # Single user
      NotificationConsoleManager.send_to_user(
        recipients,
        type: template[:type],
        title: title,
        body: body,
        data: data
      )
    when Array
      # Multiple users
      NotificationConsoleManager.send_to_users(
        recipients,
        type: template[:type],
        title: title,
        body: body,
        data: data
      )
    when :all
      # All users
      NotificationConsoleManager.send_to_all(
        type: template[:type],
        title: title,
        body: body,
        data: data
      )
    else
      puts "Invalid recipient type. Use a user ID, an array of user IDs, or :all"
      return false
    end

    true
  end

  # Interactive template creation
  def self.interactive_create
    puts "\n📝 Create a New Notification Template"

    # Get template name
    name = ""
    loop do
      name = NotificationConsoleManager.prompt_input("Enter template name (letters, numbers, underscores only):")
      break if name =~ /^[a-zA-Z0-9_]+$/
      puts "Invalid name format. Use only letters, numbers, and underscores."
    end

    # Check if template already exists
    if @templates[name]
      puts "Template '#{name}' already exists."
      return if NotificationConsoleManager.prompt_yes_no("Do you want to update it instead?")
      return update_interactive(name)
    end

    # Get template type
    type = NotificationConsoleManager.prompt_options(
      "Select notification type:",
      NotificationConsoleManager::NOTIFICATION_TYPES.map { |t| { value: t, label: t.to_s.titleize } }
    )

    # Get template content
    title = NotificationConsoleManager.prompt_input("Enter template title (use %{variable} for placeholders):")
    body = NotificationConsoleManager.prompt_input("Enter template body (use %{variable} for placeholders):")

    # Create the template
    create(name, type: type, title: title, body: body)
  end

  # Interactive template update
  def self.interactive_update
    # List templates and select one
    templates = list
    return if templates.empty?

    name = NotificationConsoleManager.prompt_input("Enter the name of the template to update:")
    update_interactive(name)
  end

  # Helper for interactive update
  def self.update_interactive(name)
    template = @templates[name.to_s]

    unless template
      puts "Template '#{name}' not found"
      return
    end

    puts "\nUpdating template '#{name}'"
    puts "Leave fields blank to keep current values"

    # Get updated values
    type = nil
    if NotificationConsoleManager.prompt_yes_no("Update type? (current: #{template[:type]})")
      type = NotificationConsoleManager.prompt_options(
        "Select new notification type:",
        NotificationConsoleManager::NOTIFICATION_TYPES.map { |t| { value: t, label: t.to_s.titleize } }
      )
    end

    title = nil
    if NotificationConsoleManager.prompt_yes_no("Update title? (current: #{template[:title]})")
      title = NotificationConsoleManager.prompt_input("Enter new template title:")
    end

    body = nil
    if NotificationConsoleManager.prompt_yes_no("Update body? (current: #{template[:body]})")
      body = NotificationConsoleManager.prompt_input("Enter new template body:")
    end

    # Update the template
    update(name, type: type, title: title, body: body)
  end

  # Interactive template deletion
  def self.interactive_delete
    # List templates and select one
    templates = list
    return if templates.empty?

    name = NotificationConsoleManager.prompt_input("Enter the name of the template to delete:")

    if NotificationConsoleManager.prompt_yes_no("Are you sure you want to delete template '#{name}'?")
      delete(name)
    end
  end

  # Interactive template usage
  def self.interactive_use
    # List templates and select one
    templates = list
    return if templates.empty?

    name = NotificationConsoleManager.prompt_input("Enter the name of the template to use:")

    template = @templates[name.to_s]
    unless template
      puts "Template '#{name}' not found"
      return
    end

    # Get recipient type
    recipient_type = NotificationConsoleManager.prompt_options(
      "Select recipient type:",
      [
        { value: :user, label: "Single user" },
        { value: :users, label: "Multiple users" },
        { value: :all, label: "All users" }
      ]
    )

    # Get user IDs based on recipient type
    recipients = nil
    case recipient_type
    when :user
      user_id = NotificationConsoleManager.prompt_input("Enter user ID:").to_i
      recipients = user_id
    when :users
      input = NotificationConsoleManager.prompt_input("Enter user IDs (comma-separated):")
      recipients = input.split(",").map(&:strip).map(&:to_i)
    when :all
      recipients = :all
    end

    # Check for placeholders in the template
    placeholders = []
    [ template[:title], template[:body] ].each do |text|
      text.scan(/%\{([^}]+)\}/).flatten.each do |placeholder|
        placeholders << placeholder unless placeholders.include?(placeholder)
      end
    end

    # Get values for placeholders
    replacements = {}
    if placeholders.any?
      puts "\nTemplate contains the following placeholders:"
      placeholders.each { |p| puts "  - #{p}" }

      placeholders.each do |placeholder|
        value = NotificationConsoleManager.prompt_input("Enter value for #{placeholder}:")
        replacements[placeholder] = value
      end
    end

    # Use the template
    use(name, recipients, data_replacements: replacements)
  end

  # Interactive menu for template management
  def self.interactive_menu
    loop do
      puts "\n📬 Notification Templates Manager"
      puts "=" * 50

      action = NotificationConsoleManager.prompt_options(
        "Select an action:",
        [
          { value: :list, label: "List templates" },
          { value: :view, label: "View a template" },
          { value: :create, label: "Create a new template" },
          { value: :update, label: "Update a template" },
          { value: :delete, label: "Delete a template" },
          { value: :use, label: "Use a template to send a notification" },
          { value: :exit, label: "Exit" }
        ]
      )

      case action
      when :list
        list
      when :view
        name = NotificationConsoleManager.prompt_input("Enter template name:")
        view(name)
      when :create
        interactive_create
      when :update
        interactive_update
      when :delete
        interactive_delete
      when :use
        interactive_use
      when :exit
        puts "Exiting Template Manager"
        break
      end
    end
  end

  # Load default templates
  def self.load_defaults
    create(
      "welcome",
      type: :info,
      title: "Welcome to PassioGo, %{name}!",
      body: "Thank you for joining PassioGo. We're excited to help you navigate your transit needs."
    )

    create(
      "route_delay",
      type: :delay,
      title: "Route %{route_name} Delayed",
      body: "Route %{route_name} is currently delayed by %{delay_minutes} minutes. We apologize for the inconvenience."
    )

    create(
      "service_disruption",
      type: :service_disruption,
      title: "Service Disruption",
      body: "There is currently a service disruption affecting %{affected_routes}. Please check the app for alternative routes."
    )

    create(
      "announcement",
      type: :announcement,
      title: "Important Announcement",
      body: "%{message}"
    )

    puts "\n✓ Loaded default templates"
  end
end
