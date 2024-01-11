var modal = document.getElementById("modal-black");

 // setric displeja
 var timeout;

 function refresh() {

    modal.style.display = "none";

     clearTimeout(timeout);

     timeout = setTimeout(() => {

        modal.style.display = "block";


     }, 300 * 1000)

 }

 refresh();



 document.addEventListener('click', refresh);
 document.addEventListener("mousemove", refresh);
 document.addEventListener("keypress", refresh);

 $(document).ready(function() {

     refresh();

 });