
/* Things to do in Barcelona */
var Barcelona = [
    {
        titlu: "Casa Batllo",
        an: 1877,
        arhitecti: ["Antoni Gaudi", "Josep Maria Jujol", "Francesc Berenguer"],
        vizitat: true,
        poza: "casa.jpeg"
    },
    {
        titlu: "Casa Mila",
        an: 1905,
        arhitecti: ["Antoni Gaudi", "Josep Maria Jujol"],
        vizitat: true,
        poza: "casa.jpeg"
    },
    {
        titlu: "Sagrada Familia",
        an: 1882,
        arhitecti: ["Antoni Gaudi", "Francisco de Paula del Villar y Lozano", "Jordi Faulí i Oller"],
        vizitat: true,
        poza: "casa.jpeg"
    },
    {
        titlu: "Palatul Muzicii Catalane",
        an: 1905,
        arhitecti: ["Lluís Domènech i Montaner"],
        vizitat: false,
        poza: "casa.jpeg"
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