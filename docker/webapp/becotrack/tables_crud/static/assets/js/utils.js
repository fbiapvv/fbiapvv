// Prehodenie fokusu pri stlaceni ENTER-----------------------------------------------------------

let input1 = document.getElementById("in_cisloDodaciehoListu");
input1.addEventListener("keyup", function (event) {
    if (event.keyCode === 13) {
        event.preventDefault();
        document.getElementById("in_pocetPaliet").focus();
    }
});
let input2 = document.getElementById("in_pocetPaliet");
input2.addEventListener("keyup", function (event) {
    if (event.keyCode === 13) {
        event.preventDefault();
        document.getElementById("in_pocetPaliet").blur();
    }
});

// modalne okno na fotky-----------------------------------------------------------
// Get the modal
var modal = document.getElementById("modalScandoc");

// Get the image and insert it inside the modal - use its "alt" text as a caption
var imgScanDoc_01 = document.getElementById("img_scandoc_01");
var imgScanDoc_02 = document.getElementById("img_scandoc_02");
var imgScanCargo = document.getElementById("img_scancargo");
var modalImg = document.getElementById("modal_img_scandoc");

imgScanDoc_01.onclick = function () {
    modal.style.display = "block";
    modalImg.src = this.src;
}

imgScanDoc_02.onclick = function () {
    modal.style.display = "block";
    modalImg.src = this.src;
}

imgScanCargo.onclick = function () {
    modal.style.display = "block";
    modalImg.src = this.src;
}
// Get the <span> element that closes the modal
var span = document.getElementsByClassName("close")[0];

// When the user clicks on <span> (x), close the modal
span.onclick = function () {
    modal.style.display = "none";
    setFocusIfEmpty();
}

modal.onclick = function () {
    modal.style.display = "none";
    setFocusIfEmpty();
}


//cakanie na nacitanie fotiek-----------------------------------------------------------

function showSpinnerScanDoc_01() {
    isDocImageLoaded_01 = false
    let spinnerScanDoc = document.getElementById("spinner-scan-doc_01");
    spinnerScanDoc.style.display = "block";

    let imageScanDoc = document.getElementById("img_scandoc_01");
    imageScanDoc.style.display = "none";
}

function showSpinnerScanDoc_02() {
    isDocImageLoaded_02 = false
    let spinnerScanDoc = document.getElementById("spinner-scan-doc_02");
    spinnerScanDoc.style.display = "block";

    let imageScanDoc = document.getElementById("img_scandoc_02");
    imageScanDoc.style.display = "none";
}

function showImageScanDoc_01() {
    isDocImageLoaded_01 = true
    let spinnerScanDoc = document.getElementById("spinner-scan-doc_01");
    spinnerScanDoc.style.display = "none";

    let imageScanDoc = document.getElementById("img_scandoc_01");
    imageScanDoc.style.display = "block";
    imageScanDoc.src = "../images/scan-doc_01.png?" + new Date().getTime();
}

function showImageScanDoc_02() {
    isDocImageLoaded_02 = true
    let spinnerScanDoc = document.getElementById("spinner-scan-doc_02");
    spinnerScanDoc.style.display = "none";

    let imageScanDoc = document.getElementById("img_scandoc_02");
    imageScanDoc.style.display = "block";
    imageScanDoc.src = "../images/scan-doc_02.png?" + new Date().getTime();
}

function showSpinnerScanCargo() {
    isCargoImageLoaded = false
    let spinnerScanDoc = document.getElementById("spinner-scan-cargo");
    spinnerScanDoc.style.display = "block";

    let imageScanDoc = document.getElementById("img_scancargo");
    imageScanDoc.style.display = "none";
}

function showImageScanCargo() {
    isCargoImageLoaded = true
    let spinnerScanDoc = document.getElementById("spinner-scan-cargo");
    spinnerScanDoc.style.display = "none";

    let imageScanDoc = document.getElementById("img_scancargo");
    imageScanDoc.style.display = "block";
    imageScanDoc.src = "../images/scan-cargo.png?" + new Date().getTime();
}

var isDocImageLoaded_01 = false
var isDocImageLoaded_02 = true
var isCargoImageLoaded = false

setInterval(function () {
    let http = new XMLHttpRequest();

    if (!isDocImageLoaded_01) {
        http.open('HEAD', "images/scan-doc_01.png", false);
        http.send();

        if (http.status == 200) {
            showImageScanDoc_01();
        }
        else {
            showSpinnerScanDoc_01();
        }
    }

    if (!isDocImageLoaded_02) {
        http.open('HEAD', "images/scan-doc_02.png", false);
        http.send();

        if (http.status == 200) {
            showImageScanDoc_02();
        }
        else {
            showSpinnerScanDoc_02();
        }
    }

    if (!isCargoImageLoaded) {

        http.open('HEAD', "images/scan-cargo.png", false);
        http.send();

        if (http.status == 200) {
            showImageScanCargo();
        }
        else {

            showSpinnerScanCargo();
        }
    }

    // console.log(http.status);
}, 1000);


var span = document.getElementsByClassName("close")[0];


function ScanDoc_01() {
    isDocImageLoaded_01 = false
    showSpinnerScanDoc_01();
    let http = new XMLHttpRequest();
    http.open('HEAD', "doscandoc_01", false);
    http.send();
    setFocusIfEmpty()
    console.log("ScanDoc01");
}

function ScanDoc_02() {
    isDocImageLoaded_01 = false
    showSpinnerScanDoc_02();
    let http = new XMLHttpRequest();
    http.open('HEAD', "doscandoc_02", false);
    http.send();
    setFocusIfEmpty()
    console.log("ScanDoc02");
}

function ScanDoc_add_02() {
    let tblBtnScanDocAdd_02 = document.getElementById("tbl-btn-scan-doc-add_02");
    let divScanDoc_02 = document.getElementById("div-scandoc_02");
    let divScandocButtonrefresh_02 = document.getElementById("div-scandoc-buttonrefresh_02");

    tblBtnScanDocAdd_02.style.display = "none";
    divScanDoc_02.style.display = "block";
    divScandocButtonrefresh_02.style.display = "block";

    ScanDoc_02()

    console.log("ScanDoc - add new");
}


function ScanCargo() {
    isCargoImageLoaded = false
    showSpinnerScanCargo();
    let http = new XMLHttpRequest();
    http.open('HEAD', "doscancargo", false);
    http.send();
    setFocusIfEmpty()
    console.log("ScanCargo");
}

function setFocusIfEmpty(){
    let input1 = document.getElementById("in_cisloDodaciehoListu");
    let input2 = document.getElementById("in_pocetPaliet");
    if (input1.value == ""){
        input1.focus()
    }
    else if (input2.value == ""){
        input2.focus()
    }
}





