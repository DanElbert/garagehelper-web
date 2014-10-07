
function flashMessage(flashType, message) {

  var flashTypeMap = {
    "notice": "success",
    "error": "danger"
  };

  var typeClass = flashType;
  if (flashTypeMap[flashType]) {
    typeClass = flashTypeMap[flashType];
  }

  typeClass = "alert-" + typeClass;

  var timeoutIdContainer = {};

  var $flashDiv = $("<div></div>")
    .html(message)
    .addClass(typeClass)
    .addClass("alert")
    //.addClass("alert-dismissible")
    .hide()
    .appendTo("#flashContainer")
    .show({effect: "pulsate", times: 1, duration: 1500})
    .bind("click.Flash", function() { $(this).hide({effect: "fade", duration: 1000}); clearTimeout(timeoutIdContainer.id); });

  timeoutIdContainer.id = setTimeout(function() {
    $flashDiv.unbind(".Flash");
    $flashDiv.hide({effect: "fade", duration: 1000});
  }, 5000);
}