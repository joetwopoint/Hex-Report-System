window.addEventListener('message', function(event) {
    if (event.data.type === 'openMenu') {
        document.getElementById('menu').style.display = 'block';
        document.getElementById('watermark').style.display = 'block';
        document.getElementById('serverName').innerText = "Sun Valley Roleplay"; // Update this line with the server name
    } else if (event.data.type === 'closeMenu') {
        document.getElementById('menu').style.display = 'none';
        document.getElementById('playerReport').style.display = 'none';
        document.getElementById('bugReport').style.display = 'none';
        document.getElementById('watermark').style.display = 'none';
    }
});

document.addEventListener('keydown', function(event) {
    if (event.key === "Escape") {
        closeForm();
    }
});

function openForm(formId) {
    document.getElementById('menu').style.display = 'none';
    document.getElementById(formId).style.display = 'block';
}

function closeForm() {
    document.getElementById('playerReport').style.display = 'none';
    document.getElementById('bugReport').style.display = 'none';
    document.getElementById('menu').style.display = 'block';
    fetch(`https://${GetParentResourceName()}/closeMenu`, {
        method: 'POST'
    }).then(resp => resp.json()).then(resp => {
        console.log(resp);
    });
}

function submitPlayerReport() {
    const serverName = document.getElementById('serverName').innerText;
    const title = document.getElementById('reportTitle').value;
    const description = document.getElementById('reportDescription').value;
    const discord = document.getElementById('discordName').value;

    if (serverName && title && description && discord) {
        fetch(`https://${GetParentResourceName()}/submitPlayerReport`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ serverName, title, description, discord })
        }).then(resp => resp.json()).then(resp => {
            console.log(resp);
            closeForm();
            // Trigger the event to show the success message
            fetch(`https://${GetParentResourceName()}/showSuccessMessage`, {
                method: 'POST'
            });
        });
    } else {
        alert('Please fill out all fields.');
    }
}

function submitBugReport() {
    const serverName = document.getElementById('serverName').innerText;
    const description = document.getElementById('bugDescription').value;
    const discord = document.getElementById('bugDiscordName').value;

    if (serverName && description && discord) {
        fetch(`https://${GetParentResourceName()}/submitBugReport`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ serverName, description, discord })
        }).then(resp => resp.json()).then(resp => {
            console.log(resp);
            closeForm();
            // Trigger the event to show the success message
            fetch(`https://${GetParentResourceName()}/showSuccessMessage`, {
                method: 'POST'
            });
        });
    } else {
        alert('Please fill out all fields.');
    }
}

function playHoverSound() {
    document.getElementById('hoverSound').play();
}

function playClickSound() {
    document.getElementById('clickSound').play();
}

function playSubmitSound() {
    document.getElementById('submitSound').play();
}

// Add hover event listeners
document.querySelectorAll('button').forEach(button => {
    button.addEventListener('mouseover', playHoverSound);
});
