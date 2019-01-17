import Foundation

class ListItemsResponse {
    static let success = """
    [
    {
        "uuid": "123abc",
        "templateUuid": "001",
        "trashed": "N",
        "createdAt": "2014-07-17T06:02:42Z",
        "updatedAt": "2018-05-03T22:28:48Z",
        "changerUuid": "C5PLG3TTQRFODJ52SVJOWEKJR2",
        "itemVersion": 1,
        "vaultUuid": "jowdkjfo2343jfoj02343kjf023u",
        "overview": {
          "URLs": [
            {
              "l": "website",
              "u": "https://example.com/login/"
            }
          ],
          "ainfo": "user@example.com",
          "pbe": 42.48481291200854,
          "pgrng": true,
          "ps": 56,
          "tags": [
            "yellow",
            "blue"
          ],
          "title": "Example Login 1",
          "url": "https://example.com/login/"
        }
      },
      {
        "uuid": "456def",
        "templateUuid": "001",
        "trashed": "N",
        "createdAt": "2017-07-14T22:43:01Z",
        "updatedAt": "2017-07-14T22:48:04Z",
        "changerUuid": "C5PLG3TTQRFODJ52SVJOWEKJR2",
        "itemVersion": 1,
        "vaultUuid": "jowdkjfo2343jfoj02343kjf023u",
        "overview": {
          "URLs": [
            {
              "u": "https://another-example.net/MyAccount/AccountCreate.aspx"
            },
            {
              "l": "website",
              "u": "https://another-example.net/myaccount/accountlogin.aspx"
            }
          ],
          "ainfo": "myaccount",
          "pbe": 42.48575749628174,
          "pgrng": true,
          "ps": 56,
          "tags": [
            "blue",
            "green"
          ],
          "title": "Example Login 2",
          "url": "https://another-example.net/MyAccount/AccountCreate.aspx"
        }
      }
    ]
    """
}
