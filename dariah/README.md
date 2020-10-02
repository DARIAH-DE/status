# How to use and embed the DARIAH-DE Status Messages

This subdirectory contains status notifications for DARIAH-DE Services. If a service is affected by error or maintenance messages, the HTML file <https://dariah-de.github.io/status/dariah/embed.html> will contain a message for a certain service, such as Geo-Browser, Publikator, and DARIAH-DE Repository.

You can add your DARIAH Service by looking at the following templates:

  * _includes/embed.html
  * _layouts/embed.html

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
