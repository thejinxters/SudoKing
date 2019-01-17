import Foundation

class GetPasswordResponse {
    static let success = """
    {
      "details": {
        "fields": [
          {
            "name": "password",
            "type": "P",
            "value": "thisismypassword"
          }
        ]
      },
      "overview": {
        "URLs": [
          {
            "u": "https://www.urls.com"
          },
          {
            "l": "website",
            "u": "https://www.website"
          }
        ],
        "tags": [
          "mytag"
        ]
      }
    }
    """
}


