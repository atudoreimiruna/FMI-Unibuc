
var solution1 = document.getElementById("solution1");
var solution2 = document.getElementById("solution2");

let cazareButton = document.getElementById("cazare-button");
cazareButton.addEventListener("click", () => {
    let number1 = parseInt(document.getElementById("price-night").value);
    let number2 = parseInt(document.getElementById("number-nights").value);
    let percent = parseInt(document.getElementById("discount").value);
    solution1.innerText = ( number1 * number2 ) - ( ( percent / 100 ) * ( number1 * number2 ) );
})

let biletButton = document.getElementById("bilet-button");
biletButton.addEventListener("click", () => {
    let number1 = parseInt(document.getElementById("first-price").value);
    let number2 = parseInt(document.getElementById("baggage-price").value);
    let number3 = parseInt(document.getElementById("tax-price").value);
    solution2.innerText = number1 + number2 + number3;
})



/* Things to do in Barcelona */
var Barcelona = [
    {
        titlu: "Casa Batllo",
        an: 1877,
        arhitecti: ["Antoni Gaudi", "Josep Maria Jujol", "Francesc Berenguer"],
        vizitat: true,
        poza: "IMG_7390.jpeg"
    },
    {
        titlu: "Casa Mila",
        an: 1905,
        arhitecti: ["Antoni Gaudi", "Josep Maria Jujol"],
        vizitat: true,
        poza: "IMG_7395.jpeg"
    },
    {
        titlu: "Sagrada Familia",
        an: 1882,
        arhitecti: ["Antoni Gaudi", "Francisco de Paula del Villar y Lozano", "Jordi Faulí i Oller"],
        vizitat: true,
        poza: "IMG_7925.jpeg"
    },
    {
        titlu: "Palatul Muzicii Catalane",
        an: 1905,
        arhitecti: ["Lluís Domènech i Montaner"],
        vizitat: false,
        poza: "IMG_7000.jpeg"
    }
]

window.onload = function() {
    let body = document.getElementsByTagName("body")[0];
    let ul = document.createElement("ul");
    for(let i = 0; i < Barcelona.length; i++) {
        let li = document.createElement("li");

        let pTitlu = document.createElement("p");
        pTitlu.innerText = Barcelona[i].titlu;

        let pAn = document.createElement("p");
        pAn.innerText = Barcelona[i].an;

        let pArhitecti = document.createElement("p");
        pArhitecti.innerText = Barcelona[i].arhitecti;

        let img = document.createElement("img");
        img.setAttribute("src", Barcelona[i].poza);
        img.setAttribute("class", "imgBarcelona");

        if(Barcelona[i].vizitat == true) {
            li.style.color = "pink";
        }

        li.appendChild(pTitlu);
        li.appendChild(pAn);
        li.appendChild(pArhitecti);
        li.appendChild(img);
        
        ul.appendChild(li)
    }

    body.appendChild(ul);
}

/* creare si stergere destinatii */
function createNewElement() {
    let div = document.getElementById("generatedContent");

    if(div.childNodes.length == 3) {
        //div.classList.add("newClass");
        div.className = "class1 class2 class3";
    }

    let newP = document.createElement("p");
    newP.innerText = "Grecia, Italia, India, Japonia, Rusia, Spania, Croația, Elveția, Dubai, Maldive, Zanzibar, Marea Britanie, România, China";
    newP.classList.add("newpclass");

    div.appendChild(newP);
}

function removeLastElement() {
    let div = document.getElementById("generatedContent");
    if(div.childNodes.length) {
        div.removeChild(div.lastChild);
    }
}

/*crearea povestii*/
let storyButton = document.getElementById("story-button");
storyButton.addEventListener("click", function() {
    let places = document.getElementById("places").value;
    let main_place = document.getElementById("main_place").value;
    let person = document.getElementById("person").value;

    let result = "Voi vizita " + main_place + " din " + places + " alături de " + person + " !";

    let story = document.getElementById("story");
    story.innerText = result;
})

