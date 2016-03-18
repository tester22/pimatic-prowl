module.exports = {
  title: "prowl config options"
  type: "object"
  required: ["apikey"]
  properties: 
    apikey:
      description:"Prowl apikey"
      type: "string"
      default: ""
      required: yes
    application: #might be overwritten by predicate
      description:"Application for the notification"
      type: "string"
      default: "pimatic"
    event: #might be overwritten by predicate
      description:"Event for the notification"
      type: "string"
      default: "Notification"
    message: #might be overwritten by predicate
      description:"Message for the notification"
      type: "string"
      default: ""
    url: #might be overwritten by predicate
      description:"URL which to send with the notification"
      type: "string"
      format: "url"
      default: ""
    priority: #might be overwritten by predicate
      description:"""Priority of the notification: send as -1 to always send as a quiet 
        notification, 1 to display as high-priority and bypass the user's quiet hours, or 2 to 
        to display as emergency"""
      type: "integer"
      default: 0
}
