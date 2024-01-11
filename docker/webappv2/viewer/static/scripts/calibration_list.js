function openCalibrationUpdate(calibrationId) {
    // Find the calibration data by ID in the json_calibration_data array
    var calibration = json_calibration_data.find(item => item.id === calibrationId);

    // Parse ISO 8601 formatted datetime strings into JavaScript Date objects
    var datetimeFrom = new Date(calibration.from);
    var datetimeTo = new Date(calibration.to);

    // Add 2 hours to the Date objects
    datetimeFrom.setHours(datetimeFrom.getHours() + 2);
    datetimeTo.setHours(datetimeTo.getHours() + 2);

    // Format the Date objects to be in a format compatible with datetime-local input
    var formattedDatetimeFrom = datetimeFrom.toISOString().slice(0, 16); // YYYY-MM-DDTHH:mm
    var formattedDatetimeTo = datetimeTo.toISOString().slice(0, 16);

    // Fetch the options for Chip and Position from Django and store them in variables.
    var chipOptions = json_chip_names.map(function(chip) {
        return `<option value="${chip.id}" ${chip.name === calibration.chip ? 'selected' : ''}>${chip.name}</option>`;
    }).join('');

    var positionOptions = json_positions.map(function(position) {
        return `<option value="${position.id}" ${position.name === calibration.position ? 'selected' : ''}>${position.name}</option>`;
    }).join('');

    // Create HTML select elements for Chip and Position options.
    var chipSelect = `<select id="swal-input-chip" class="swal2-input">${chipOptions}</select>`;
    var positionSelect = `<select id="swal-input-position" class="swal2-input">${positionOptions}</select>`;


    // Open the SweetAlert2 popup with pre-filled data
    Swal.fire({
        title: 'Upraviť kalibráciu',
        html:
           `<div class="swal2-input-container">
                <label for="swal-input-chip">Čip:</label>
                ${chipSelect}
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-position">Pozícia:</label>
                ${positionSelect}
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-datetime-from">Od:</label>
                <input id="swal-input-datetime-from" type="datetime-local" class="swal2-input" value="${formattedDatetimeFrom}">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-datetime-to">Do:</label>
                <input id="swal-input-datetime-to" type="datetime-local" class="swal2-input" value="${formattedDatetimeTo}">
            </div>
            <button id="swal-button-delete" class="swal2-confirm swal2-styled" onclick="deleteCalibration('${calibration.id}')">Vymazať kalibráciu</button>`,
        showCancelButton: true,
        confirmButtonText: 'Uložiť',
        cancelButtonText: 'Zrušiť',
        preConfirm: () => {
            // Get values from the SweetAlert2 input fields
            var chipId = document.getElementById('swal-input-chip').value;
            var positionId = document.getElementById('swal-input-position').value;
            var datetimeFrom = document.getElementById('swal-input-datetime-from').value;
            var datetimeTo = document.getElementById('swal-input-datetime-to').value;

            var calibrationData = {
                calibrationId: calibrationId,
                chipId: chipId,
                positionId: positionId,
                datetimeFrom: datetimeFrom,
                datetimeTo: datetimeTo,
            };

            fetch('/update_calibration/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify(calibrationData),
            })
            .then(response => {
                if (response.ok) {
                    Swal.fire({
                      position: 'top',
                      title: 'Kalibrácia upravená.',
                      icon: 'success',
                      showConfirmButton: false,
                      timer: 900
                    });
                    setTimeout(function() {
                          location.reload();
                        }, 900);
                } else {
                    throw new Error('Failed to update calibration data');
                }
            })
            .catch(error => {
                // Handle any network or other errors here.
                console.error('Error:', error);
            });
        }
    });
}

function deleteCalibration(calibrationId) {
    var calibration = json_calibration_data.find(item => item.id === calibrationId);

    // Display a confirmation window with SweetAlert2
    Swal.fire({
        title: `Určite chcete vymazať kalibráciu ${calibration.id} pre ${calibration.chip}?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonText: 'Áno',
        cancelButtonText: 'Zrušiť',
    }).then((result) => {
        // If the user confirms the deletion
        if (result.isConfirmed) {
            fetch(`/delete_calibration_server/${calibration.id}/`, {
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
                      title: 'Kalibrácia vymazaná.',
                      icon: 'success',
                      showConfirmButton: false,
                      timer: 900
                    });
                    setTimeout(function() {
                          location.reload();
                        }, 900);
                    } else {
                        Swal.fire({
                            title: 'Chyba pri vymazávaní kalibrácie',
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

function openNewCalibrationPopup() {

    var chipOptions = json_chip_names.map(function(chip) {
        return `<option value="${chip.id}">${chip.name}</option>`;
    }).join('');

    var positionOptions = json_positions.map(function(position) {
        return `<option value="${position.id}">${position.name}</option>`;
    }).join('');

    // Create HTML select elements for Chip and Position options.
    var chipSelect = `<select id="swal-input-chip" class="swal2-input">${chipOptions}</select>`;
    var positionSelect = `<select id="swal-input-position" class="swal2-input">${positionOptions}</select>`;

    Swal.fire({
        title: 'Nová kalibrácia',
        html:
           `<div class="swal2-input-container">
                <label for="swal-input-chip">Čip:</label>
                ${chipSelect}
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-position">Pozícia:</label>
                ${positionSelect}
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-datetime-from">Od:</label>
                <input id="swal-input-datetime-from" type="datetime-local" class="swal2-input">
            </div>
            <div class="swal2-input-container">
                <label for="swal-input-datetime-to">Do:</label>
                <input id="swal-input-datetime-to" type="datetime-local" class="swal2-input">
            </div>`,
        confirmButtonText: 'Vytvoriť',
        cancelButtonText: 'Zrušiť',
        showCancelButton: true,
        preConfirm: () => {
            var chipId = document.getElementById('swal-input-chip').value;
            var positionId = document.getElementById('swal-input-position').value;
            var datetimeFrom = document.getElementById('swal-input-datetime-from').value;
            var datetimeTo = document.getElementById('swal-input-datetime-to').value;

            var calibrationData = {
                chipId: chipId,
                positionId: positionId,
                datetimeFrom: datetimeFrom,
                datetimeTo: datetimeTo,
            };

            fetch('/create_new_calibration/', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRFToken': csrf_token,
                },
                body: JSON.stringify(calibrationData),
            })
            .then((response) => {
                if (response.ok) {
                    Swal.fire({
                      position: 'top',
                      title: 'Kalibrácia vytvorená.',
                      icon: 'success',
                      showConfirmButton: false,
                      timer: 900
                    });
                    setTimeout(function() {
                          location.reload();
                        }, 900);
                    } else {
                        Swal.fire({
                            title: 'Chyba pri vytváraní kalibrácie',
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
                "targets": [2, 3, 4, 5],
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