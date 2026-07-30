# Returning an Image with a DataScript

The function `avi.http.response` returns a simple web page, such as a custom 404 error page. Making such a page more seamless or branded might require incorporating images, icons, or pictures. DataScripts can serve these images with a few additional steps.

When a client requests an image, or an HTML page that has an image embedded within it, though the DataScript can return the image, the image must first be converted to Base64 encoding. This conversion can be done using free utility websites. Upload the desired image to a site such as `www.browserling.com/tools/image-to-base64` to convert the image to a Base64-encoded version. Copy and paste the encoded output into your DataScript. In the following HTML code, replace the xxxx with the Base64-encoded image. Change the image type to the appropriate one for this image: GIF, JPEG or PNG.

```html
<img src='data:image/gif;base64, xxxx' />
```

The images can be embedded within the HTML or be as a standalone request. As DataScripts can be of any size, using larger images is not an issue.

## Example

This simple page returns an embedded GIF within the HTML.

```lua
page = "<html><body><p><center><b>Here is a sample embedded image served from a DataScript</b></p>"
page = page .. "<img style='display:block; width:80px;height:80px;' src='data:image/gif;base64, R0lGODlhCAATAOYAAP//////AP8A//BAAAD//wD/AAAA/WAAAPQAXfoAu/8GwPQG8PIE+uoC/7sB+rUC/60B/54J/24A/FYA/FIA/OWA/z0A8R8A9BKA/xEA8AOA+A0A9w0D+g4m+gAk/QAx+QA3/gA89gBL/w1Q/w9v+gF7/wCF/wCV/wCb/wCt/wCl/wS9/gDS/wDa/wDl/wfo/gzs/wrz/wD9/wD/6gD/3Qf/1Qf/zA3/zAD/yAD7jwP/iAr8dgD7bAD/ZwD4PgD+LgD/IgH8Gw7/Dh//CR/9AFz+AGX9ALD/Bf///WAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAGALAAAAAAIAAgAAAdCgAgJDREWGyMrCgsQFRkiKjEMDxQaICkyOA4THCEOMDY8EhcfJy830z8YHSYUNT1BQx41LTQ6QERGJCwzOT5CRUEBADs='/>"
page = page .. "</center></body></html>"

avi.http.response(200, {content_type="text/html"}, page)
```
