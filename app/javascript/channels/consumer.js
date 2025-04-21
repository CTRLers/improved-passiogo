// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

consumer.connection.events.addEventListener('connected', () => {
  console.log('Connected to Action Cable')
})

consumer.connection.events.addEventListener('disconnected', () => {
  console.log('Disconnected from Action Cable')
})

consumer.connection.events.addEventListener('rejected', () => {
  console.log('Connection rejected')
})

export default consumer
