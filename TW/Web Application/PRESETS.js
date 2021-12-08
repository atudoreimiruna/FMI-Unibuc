function changeImage() {
    let img = document.getElementById("myImg");
    let source = img.getAttribute("src");
    img.setAttribute("class", "imgEdit");

    console.log(source);
    if(source == "IMG_7868.jpeg") {
        img.setAttribute("src", "SB_after.JPG");
    } else {
        img.setAttribute("src", "IMG_7868.jpeg");
    }
}

/*Cameras*/
var currentCameraId;

function fetchCameras() {
    let content = document.getElementById("content");

    let body = document.getElementsByTagName("body")[0];
    let p = document.createElement("p");
    p.innerText = "loading...";
    p.setAttribute("id", "loading");
    body.appendChild(p);

    fetch('http://localhost:3000/cameras', {
    method: 'get' 
    }).then(function(response) {
        response.json().then((data) => {
            if(data.length) {
                body.removeChild(p);
            }

            for(let i = 0; i < data.length; i++){
                let image = document.createElement("img");
                image.setAttribute("src", data[i].img);
                image.width = 100;
                content.appendChild(image);

                let h3 = document.createElement("h3");
                h3.innerText = data[i].name;
                content.appendChild(h3);

                // creare buton de edit
                let editButton = document.createElement("button");
                let editText = document.createTextNode("Edit");
                editButton.appendChild(editText);
                editButton.onclick = function() {
                    document.getElementById("name").value = data[i].name;
                    document.getElementById("image").value = data[i].img;
                    currentDogId = data[i].id;
                }
                content.appendChild(editButton);

                // creare buton de delete
                let deleteButton = document.createElement("button");
                let deleteText = document.createTextNode("Delete");
                deleteButton.appendChild(deleteText);
                deleteButton.onclick = function() {
                    deleteCamera(data[i].id);
                }
                content.appendChild(deleteButton);

                let hr = document.createElement("hr");
                content.appendChild(hr);
            }
        })
    })
}

fetchCameras()

// adaugare
function addCamera() {
    var name = document.getElementById("name").value;
    var img = document.getElementById("image").value;
    var newCamera = {
        name: name,
        img: img
    }
    fetch('http://localhost:3000/cameras', {
        method: 'post', 
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(newCamera)
    }).then(function(response) {
        console.log(response);
    })
}

// editare
function editCamera() {
    var name = document.getElementById("name").value;
    var img = document.getElementById("image").value;

    var newCamera = {
        name: name,
        img: img
    }

    fetch('http://localhost:3000/cameras/' + currentCameraId, { 
        method: 'put', 
        headers: {
            'Content-Type': 'application/json' 
        },
        body: JSON.stringify(newCamera) 
    }).then(function(response) {
    })
}

// stergere
function deleteCamera(id) {
    fetch('http://localhost:3000/cameras/' + id, {
        method: 'delete',
        headers: {
            'Content-Type': 'application/json'
        }
    }).then(function(response) {
        window.location.reload();
    })
}