
function openPositionUpdate(positionId) {
    var position = json_position_data.find(item => item.id === positionId);

    // Open the SweetAlert2 popup with pre-filled data
    Swal.fire({
        title: 'Upraviť pozíciu',
        html:
           `<div class="swal2-input-container">
                <label for="swal-input-name">Názov:</label>
                <input id="swal-input-name" class="swal2-input" value="${position.name}">
            </div>
            <div class="swal2-input-container-active">
                <label for="swal-input-active">Aktívna:</label>
                <input id="swal-input-active" class="swal2-input" type="checkbox" ${position.active === 'True' ? 'checked' : ''}>
            </div>
            <button id="swal-button-delete" class="swal2-confirm swal2-styled" onclick="deletePosition('${position.id}')">Vymazať pozíciu</button>`,
        showCancelButton: true,
        confirmButtonText: 'Uložiť',
        cancelButtonText: 'Zrušiť',
        preConfirm: () => {
            // Get values from the SweetAlert2 input fields
            var name = document.getElementById('swal-input-name').value;
            var activeCheckbox = document.getElementById('swal-input-active');
            var active = activeCheckbox.checked;

            var positionData = {
                positionId: positionId,
                name: name,
                active: active,
            };

            fetch('/update_position/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify(positionData),
            })
            .then(response => {
                if (response.ok) {
                    Swal.fire({
                      position: 'top',
                      title: 'Pozícia upravená.',
                      icon: 'success',
                      showConfirmButton: false,
                      timer: 900
                    });
                    setTimeout(function() {
                          location.reload();
                        }, 900);
                } else {
                    throw new Error('Failed to update position data');
                }
            });
        },
    });
}

function deletePosition(positionId) {
    var position = json_position_data.find(item => item.id === positionId);

    // Display a confirmation window with SweetAlert2
    Swal.fire({
        title: `Určite chcete vymazať pozíciu ${position.name}?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Áno',
        cancelButtonText: 'Zrušiť',
    }).then((result) => {
        // If the user confirms the deletion
        if (result.isConfirmed) {
            fetch(`/delete_position/${position.id}/`, {
                method: 'DELETE',
                headers: {
                    'X-CSRFToken': csrf_token, // Include the CSRF token in the headers
                },
            })
                .then((response) => {
                    if (response.ok) {
                        // If the deletion was successful, display a success message
                    Swal.fire({
                      position: 'top',
                      title: 'Pozícia vymazaná.',
                      icon: 'success',
                      showConfirmButton: false,
                      timer: 900
                    });
                    setTimeout(function() {
                          location.reload();
                        }, 900);
                    } else {
                        Swal.fire({
                            title: 'Chyba pri vymazávaní pozície.',
                            icon: 'error',
                        });
                    }
                })
                .catch((error) => {
                    console.error('Error:', error);
                });
        }
    });
}

function openNewPositionPopup() {

    Swal.fire({
        title: 'Nová pozícia',
        html:
           `<div class="swal2-input-container">
                <label for="swal-input-name">Názov:</label>
                <input id="swal-input-name" class="swal2-input">
            </div>
            <div class="swal2-input-container-active">
                <label for="swal-input-active">Aktívna:</label>
                <input id="swal-input-active" class="swal2-input" type="checkbox" checked>
            </div>`,
        confirmButtonText: 'Vytvoriť',
        cancelButtonText: 'Zrušiť',
        showCancelButton: true,
        preConfirm: () => {
            var name = document.getElementById('swal-input-name').value;
            var activeCheckbox = document.getElementById('swal-input-active');
            var active = activeCheckbox.checked;

            var positionData = {
                name: name,
                active: active,
            };

            fetch('/create_new_position/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify(positionData),
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
                        title: `Pozícia ${name} vytvorená.`,
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

$(document).ready(function() {
    $('#chips-table').DataTable({
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
        "lengthMenu": [15, 30, 50, 100],
        "pageLength": 15,
        // Other DataTable options...
        "columnDefs": [
            {
                "targets": [2, 3],
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