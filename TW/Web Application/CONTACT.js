/* pentru evenimentul cu mouse ul */
function mOver(obj) {
    obj.innerHTML = "atudorei.miruna@yahoo.ro"
    }

    function mOut(obj) {
    obj.innerHTML = "I'll wait your messages on this email address!"
    }

/* mesaje */
var currentPersonId;
 
function fetchPeople() {
    let content = document.getElementById("content");
 
    let body = document.getElementsByTagName("body")[0];
    let p = document.createElement("p");
    p.innerText = "Loading...";
    p.setAttribute("id", "loading");
    body.appendChild(p);
 
    fetch('http://localhost:3001/people', {
        method: 'get' 
    }).then(function(response) {
        response.json().then((data) => {
            if(data.length) {
                body.removeChild(p);
            }
 
            for(let i = 0; i < data.length; i++){
                let h3 = document.createElement("h3");
                h3.innerText = data[i].name;
                content.appendChild(h3);
 
                let parere = document.createElement("p");
                parere.innerText = data[i].message;
                content.appendChild(parere);
 
                // creare buton de edit
                let editButton = document.createElement("button");
                editButton.setAttribute("id", "edit-button");
                let editText = document.createTextNode("Edit");
                editButton.appendChild(editText);
                editButton.onclick = function() {
                    document.getElementById("name").value = data[i].name;
                    document.getElementById("message").value = data[i].message;
                    currentPersonId = data[i].id;
                }
                content.appendChild(editButton);
 
                // creare buton de delete
                let deleteButton = document.createElement("button");
                deleteButton.setAttribute("id", "delete-button");
                let deleteText = document.createTextNode("Delete");
                deleteButton.appendChild(deleteText);
                deleteButton.onclick = function() {
                    deletePerson(data[i].id);
                }
                content.appendChild(deleteButton);
 
                let hr = document.createElement("hr");
                content.appendChild(hr);
            }
        })
    })
 
}
 
fetchPeople()
 
// adaugare - post
function addFeedback() {
    var name = document.getElementById("name").value;
    var message = document.getElementById("message").value;
    var newPerson = {
        name: name,
        message: message
    }
    fetch('http://localhost:3001/people', {
        method: 'post', // vrem sa introducem ceva nou in baza de date
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(newPerson)
    }).then(function(response) {
        console.log(response);
    })
}
 
 
// editare - put
function editFeedback() {
    var name = document.getElementById("name").value;
    var message = document.getElementById("message").value;
 
    var newPerson = {
        name: name,
        message: message
    }
 
    fetch('http://localhost:3001/people/' + currentPersonId, {
        method: 'put', 
        headers: {
            'Content-Type': 'application/json' 
        },
        body: JSON.stringify(newPerson)
    }).then(function(response) {
    })
}
 
// stergere - delete
function deletePerson(id) {
    fetch('http://localhost:3001/people/' + id, {
        method: 'delete',
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(function(response) {
        window.location.reload();
    })
}