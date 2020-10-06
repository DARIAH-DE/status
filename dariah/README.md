# How to use and embed the DARIAH-DE Status Messages

This subdirectory contains status notifications for DARIAH-DE Services. If a service is affected by error or maintenance messages, the HTML file <https://dariah-de.github.io/status/dariah/embed.html> will contain a message for a certain service, such as Geo-Browser, Publikator, and DARIAH-DE Repository.

You can add your DARIAH Service by looking at the following templates:

  * _includes/embed.html
  * _layouts/embed.html

You then will get status messages in the embed.html such as:

```
<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <meta charset="utf-8"></meta>
    <title>DARIAH-DE Service Status</title>
    <link rel="stylesheet" type="text/css" href="/dariah/embed.css"/>
  </head>
  <body>

    <div class="geobrowser_status error">
      <!-- dh_geobrowser_is_actually_affected -->
      <p lang="en">
        <b>Authorization Service of the DARIAH AAI temporarily unavailable</b><br/>
        Effective from <time datetime="2020-10-01 9:00">2020-10-01 9:00</time>.
        <br/>
        The authorization service of the DARIAH AAI is temporarily unavailable. We are currently solving the problem, we apologize for any inconvenience.
      </p>
    </div>

    <div class="repository_status warning">
      <!-- dh_repository_is_actually_affected -->
      <p lang="en">
        <b>Maitenance on DARIAH-DE Repository Website</b><br/>
        Effective from <time datetime="2020-10-11 14:00">2020-10-11 14:00</time>.
       <br/>
        The DARIAH-DE Repository will be temporarily unavailable. We apologize for any inconvenience!
      </p>
    </div>

  </body>
</html>
```

Then use JavaScript to embed the DARIAH-DE Error and Warning Status Messages however you like:

```
function getEmbeddedStatus() {
    $.ajax({
        url: "https://dariah-de.github.io/status/dariah/embed.html",
        type: 'GET',
        success: function(data) {
            var errorHtml = (new DOMParser()).parseFromString(data, 'text/html')
                .querySelector('.geobrowser_status.error');
            var warningHtml = (new DOMParser()).parseFromString(data, 'text/html')
                .querySelector('.geobrowser_status.warning');
            if (errorHtml) {
                // Do something with it!
                console.log(errorHtml.innerHTML);
            }
            if (warningHtml) {
                // Do something with it!
                console.log(warningHtml.innerHTML);
            }
        }
    });
```