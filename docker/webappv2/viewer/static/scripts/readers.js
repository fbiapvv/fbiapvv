$(document).ready(function() {
    var table = $('#chips-table').DataTable({
        "language": {
            "lengthMenu": "Zobraziť _MENU_ záznamov na stránku",
            "zeroRecords": "Žiadne záznamy nenájdené",
            "info": "Zobrazuje sa _START_ až _END_ z celkových _TOTAL_ záznamov",
            "infoEmpty": "Zobrazuje sa 0 až 0 z 0 záznamov",
            "infoFiltered": "(filtrované z celkových _MAX_ záznamov)",
            "search": "Hľadať:",
            "paginate": {
                "first": "Prvá",
                "previous": "Predchádzajúca",
                "next": "Nasledujúca",
                "last": "Posledná"
            },
            "aria": {
                "sortAscending": ": aktivujte stĺpec na vzostupné zoradenie",
                "sortDescending": ": aktivujte stĺpec na zostupné zoradenie"
            }
        },
        "lengthMenu": [16, 30, 50, 100],
        "pageLength": 16,
        // Other DataTable options...

        "columnDefs": [
            {
                "targets": [2, 3, 4],
                "render": function(data, type, row) {
                    if (type === 'sort' || type === 'type') {
                        const parsedDate = moment(data, "DD.MM.YYYY, HH:mm:ss").toDate();
                        console.log(`Sorting: ${data} -> ${parsedDate}`);
                        return parsedDate;
                    }
                    return data;
                }
            }
        ]
    });
});


function openReaderUpdate(readerId) {
  var reader = json_readers_data.find(item => item.id === readerId);

  // Create input elements for the name and active status
  var nameInput = document.createElement('input');
  nameInput.value = reader.name;

  var activeCheckbox = document.createElement('input');
  activeCheckbox.type = 'checkbox';
  activeCheckbox.checked = reader.active === 'True';

  // Create a Swal pop-up with the input elements and pre-fill the values
  Swal.fire({
    title: `Upraviť čítačku ${reader.name}`,
    html: `
      <label for="name">Názov</label>
      <input id="name" class="swal2-input" value="${nameInput.value}">
    <div class="swal2-input-container-active">
      <label for="active">Aktívna</label>
      <input id="active" type="checkbox" class="swal2-input" ${activeCheckbox.checked ? 'checked' : ''}>
    </div>
    `,
        confirmButtonText: 'Uložiť',
        cancelButtonText: 'Zrušiť',
        showCancelButton: true,
        preConfirm: () => {
            var name = document.getElementById('name').value;
            var activeCheckbox = document.getElementById('active');
            var active = activeCheckbox.checked;

            if (json_readers_data.some(reader => reader.name === name)) {
                Swal.showValidationMessage('Názov už existuje');
                return false; // Prevent proceeding
            }

            var readerData = {
                readerId: readerId,
                name: name,
                active: active,
            };

            fetch('/update_reader/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify(readerData),
            })
           .then((response) => {
                if (response.ok) {
                    return response.json();
                } else {
                    throw new Error('Network response was not ok');
                }
            })
            .then((data) => {
                if (data.success) {
                    Swal.fire({
                        position: 'top',
                        title: `Čítačka ${name} upravená.`,
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 900
                    });
                    setTimeout(function () {
                        location.reload();
                    }, 900);
                } else {
                    Swal.fire({
                        icon: 'error',
                        text: data.message
                    });
                }
            })
            .catch((error) => {
                console.error('Error:', error);
            });
        }
    });
}