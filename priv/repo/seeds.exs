# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Transhook.Repo.insert!(%Transhook.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Transhook.Repo.insert!(%Transhook.Webhook.Hook{
  dispatcher: %Transhook.Webhook.Dispatcher{
    content_type: "application/json",
    http_method: "post",
    payload_template: ~s"""
    {
      "activity":"[{$.project.name}] New release",
      "title":"",
      "icon":"{$.user_avatar}",
      "body":"",
      "attachments":[
       {
        "type":"Card",
        "fallback":"The attachments are not supported by your client.",
        "color":"#9C1A22",
        "thumb_url":"{$.project.avatar_url}",
        "fields":[
         {
          "title":"Project",
          "value":"{$.project.web_url}",
          "style":"Long"
         },
         {
          "title":"Version",
          "value":"{$.ref}",
          "style":"Short"
         },
         {
          "title":"SHA",
          "value":"{$.checkout_sha}",
          "style":"Short"
         }
        ]
       }
      ]
     }
    """,
    url: "https://hooks.glip.com/webhook/a4ac15c4-537e-4345-a305-db1bb79dc6a6"
  },
  responder: %Transhook.Webhook.Responder{
    content_type: "application/json",
    payload: "{\"ok\": \"ok\"}",
    status_code: 200
  },
  name: "Gitlab Project to Glip"
})
