function openInfo(event) {
  var infoPopup = document.getElementById("info-popup");
  infoPopup.style.display = "block";

  // Adjust the position of the info popup relative to the button. You can adjust the values to position it as desired.
  var buttonRect = event.target.getBoundingClientRect();
  infoPopup.style.top = buttonRect.bottom + "px";
  infoPopup.style.left = buttonRect.left + "px";

  // Add text or content to the info popup here if needed.
  infoPopup.innerHTML = "Dátum + čas zadajte v tvare 00.00.0000 00:00(:00) <br> samotný dátum 00.00.(0000) <br> samotný čas 00:00(:00)";

  // Prevent the click event from propagating to the document, so it doesn't immediately close the popup.
  event.stopPropagation();
}

function closeInfo() {
  var infoPopup = document.getElementById("info-popup");
  infoPopup.style.display = "none";
}

// Attach the openInfo function to the info button's click event.
var infoButton = document.querySelector(".info-button");
infoButton.addEventListener("click", openInfo);

// Listen for clicks on the document to close the info popup when clicking anywhere else.
document.addEventListener("click", function(event) {
  if (event.target !== infoButton) {
    closeInfo();
  }
});