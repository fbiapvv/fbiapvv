function openChipUpdate(chipId) {
    // Find the chip data by ID in the json_chips_data array
    var chip = json_chips_data.find(item => item.id === chipId);

    // Open the SweetAlert2 popup with pre-filled data
    Swal.fire({
        title: 'Upraviť čip',
        html:
           `<div class="swal2-input-container">
                <label for="swal-input-name">Názov:</label>
                <input id="swal-input-name" class="swal2-input" value="${chip.name !== 'None' ? chip.name : ''}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-local-name">Lokálny názov:</label>
                <input id="swal-input-local-name" class="swal2-input" value="${chip.local_name !== 'None' ? chip.local_name : ''}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-UUIDs">UUIDs:</label>
                <input id="swal-input-UUIDs" class="swal2-input" value="${chip.UUIDs !== 'None' ? chip.UUIDs : ''}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-proximity">Proximity:</label>
                <input id="swal-input-proximity" class="swal2-input" type="number" value="${chip.proximity}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-accuracy">Accuracy:</label>
                <input id="swal-input-accuracy" class="swal2-input" type="number" step="0.01" value="${chip.accuracy}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-minor">Minor:</label>
                <input id="swal-input-minor" class="swal2-input" type="number" step="1" value="${chip.minor}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-major">Major:</label>
                <input id="swal-input-major" class="swal2-input" type="number" step="1" value="${chip.major}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-tx-power">tx_power:</label>
                <input id="swal-input-tx-power" class="swal2-input" value="${chip.tx_power !== 'None' ? chip.tx_power : ''}">
            </div>
            <div class="swal2-input-container-active">
                <label for="swal-input-active">Aktívny:</label>
                <input id="swal-input-active" class="swal2-checkbox" type="checkbox" ${chip.active === 'True' ? 'checked' : ''}>
            </div>
            <button id="swal-button-delete" class="swal2-confirm swal2-styled" onclick="deleteChip('${chip.id}')">Vymazať čip</button>`,
        showCancelButton: true,
        confirmButtonText: 'Uložiť',
        cancelButtonText: 'Zrušiť',
        preConfirm: () => {
            // Get values from the SweetAlert2 input fields
            var name = document.getElementById('swal-input-name').value;
            var local_name = document.getElementById('swal-input-local-name').value;
            var UUIDs = document.getElementById('swal-input-UUIDs').value;
            var proximity = document.getElementById('swal-input-proximity').value;
            var accuracy = document.getElementById('swal-input-accuracy').value;
            var minor = document.getElementById('swal-input-minor').value;
            var major = document.getElementById('swal-input-major').value;
            var tx_power = document.getElementById('swal-input-tx-power').value;
            var active = document.getElementById('swal-input-active').checked; // for the checkbox input

            if (!name) {
                Swal.showValidationMessage('Názov musí byť vyplnený.');
                return false; // Prevent closing the popup
            }

            // Create an object with all the data
            var chipData = {
                chipId: chipId,
                name: name,
                local_name: local_name,
                UUIDs: UUIDs,
                proximity: proximity,
                accuracy: accuracy,
                minor: minor,
                major: major,
                tx_power: tx_power,
                active: active,
            };

            fetch('/update_chip/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify(chipData),
            })
            .then(response => response.json())  // Parse response as JSON
            .then(data => {
                if (data.status === 'success') {
                    Swal.fire({
                        position: 'top',
                        title: 'Čip upravený.',
                        icon: 'success',
                        showConfirmButton: false,
                        timer: 900
                    });
                    setTimeout(function() {
                        location.reload();
                    }, 900);
                } else {
                    Swal.fire({
                        icon: 'error',
                        text: data.message
                    });
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
        },
    });
}

function deleteChip(chipId) {
    // Find the chip data by ID in the json_chips_data array
    var chip = json_chips_data.find(item => item.id === chipId);

    // Display a confirmation window with SweetAlert2
    Swal.fire({
        title: `Určite chcete vymazať ${chip.name}?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Áno',
        cancelButtonText: 'Zrušiť',
    }).then((result) => {
        // If the user confirms the deletion
        if (result.isConfirmed) {
            fetch(`/delete_chip/${chip.id}/`, {
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
                      title: 'Čip vymazaný.',
                      icon: 'success',
                      showConfirmButton: false,
                      timer: 900
                    });
                    setTimeout(function() {
                          location.reload();
                        }, 900);
                    } else {
                        Swal.fire({
                            title: 'Chyba pri vymazávaní čipu',
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

function openNewChipPopup() {
    Swal.fire({
        title: 'Nový čip',
        html:
            `<div class="swal2-input-container">
                <label for="name">Názov:</label>
                <input id="name" class="swal2-input" placeholder="Názov">
            </div>
            <div class="swal2-input-container">
                <label for="local_name">Lokálny názov:</label>
                <input id="local_name" class="swal2-input" placeholder="Lokálny názov">
            </div>
            <div class="swal2-input-container">
                <label for="uid">UID:</label>
                <input id="uid" class="swal2-input" placeholder="UID">
            </div>
            <div class="swal2-input-container">
                <label for="UUIDs">UUIDs:</label>
                <input id="UUIDs" class="swal2-input" placeholder="UUIDs">
            </div>
            <div class="swal2-input-container">
                <label for="proximity">Proximity:</label>
                <input id="proximity" class="swal2-input" type="number" step="0.01" placeholder="Proximity">
            </div>
            <div class="swal2-input-container">
                <label for="accuracy">Accuracy:</label>
                <input id="accuracy" class="swal2-input" type="number" step="0.01" placeholder="Accuracy">
            </div>
            <div class="swal2-input-container">
                <label for="minor">Minor:</label>
                <input id="minor" class="swal2-input" type="number" step="1" placeholder="Minor">
            </div>
            <div class="swal2-input-container">
                <label for="major">Major:</label>
                <input id="major" class="swal2-input" type="number" step="1" placeholder="Major">
            </div>
            <div class="swal2-input-container">
                <label for="tx_power">tx_power:</label>
                <input id="tx_power" class="swal2-input" placeholder="tx_power">
            </div>`,
        confirmButtonText: 'Vytvoriť',
        cancelButtonText: 'Zrušiť',
        showCancelButton: true,
        preConfirm: () => {
            var name = Swal.getPopup().querySelector('#name').value;
            var uid = Swal.getPopup().querySelector('#uid').value;
            var UUIDs = Swal.getPopup().querySelector('#UUIDs').value;
            var local_name = Swal.getPopup().querySelector('#local_name').value;
            var proximity = Swal.getPopup().querySelector('#proximity').value;
            var accuracy = Swal.getPopup().querySelector('#accuracy').value;
            var minor = Swal.getPopup().querySelector('#minor').value;
            var major = Swal.getPopup().querySelector('#major').value;
            var tx_power = Swal.getPopup().querySelector('#tx_power').value;

            if (!name || !uid) {
                Swal.showValidationMessage('Názov a uid musia byť vyplnené.');
                return false; // Prevent closing the popup
            }

            fetch('/create_new_chip/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify({
                    name: name,
                    uid: uid,
                    UUIDs: UUIDs,
                    local_name: local_name,
                    proximity: proximity,
                    accuracy: accuracy,
                    minor: minor,
                    major: major,
                    tx_power: tx_power,
                }),
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
                        title: `Čip ${name} vytvorený.`,
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
        "lengthMenu": [15, 30, 50, 100],
        "pageLength": 15,
        // Other DataTable options...

        "columnDefs": [
            {
                "targets": [2, 3],
                "render": function(data, type, row) {
                    if (type === 'sort' || type === 'type') {
                        var parsedDate = moment(data, "DD.MM.YYYY, HH:mm:ss").toDate();
                        console.log(`Sorting: ${data} -> ${parsedDate}`);
                        return parsedDate;
                    }
                    return data;
                }
            }
        ]
    });
});