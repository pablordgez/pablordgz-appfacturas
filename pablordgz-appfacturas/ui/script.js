function loadBills(bills){
    document.getElementById('facturas').innerHTML = '';
    let title = document.createElement('h1');
    title.classList.add('titulo');
    title.innerHTML = 'Facturas';
    document.getElementById('facturas').appendChild(title)
    for (let i = 0; i < bills.length; i++){
        addBill(bills[i]);
    }
}

function addBill(bill){
    if(bill.status == "PENDING"){
        let billDiv = document.createElement('div');
        billDiv.classList.add('factura');
        let title = document.createElement('h1');
        title.classList.add('concepto');
        title.innerHTML = bill.from;
        let desc = document.createElement('p');
        desc.classList.add('descripcion');
        desc.innerHTML = bill.message;
        let precio = document.createElement('p');
        precio.classList.add('dinero');
        precio.innerHTML = bill.amount + "$";
        let pagar = document.createElement('button');
        pagar.classList.add('pagar');
        pagar.innerHTML = 'Pagar';
        
        billDiv.appendChild(title);
        billDiv.appendChild(desc);
        billDiv.appendChild(precio);
        billDiv.appendChild(pagar);
        billDiv.setAttribute('id', bill.id);
        document.getElementById('facturas').appendChild(billDiv);
    }
}

document.addEventListener('click', (event) => {
    if (event.target.classList.contains('pagar')){
        let id = event.target.parentElement.id;
        payBill(id);
    }
})


function payBill(id){
    fetch('https://pablordgz-appfacturas/payBill', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({id: id})
    }).then(resp => resp.json()).then(resp => console.log(resp));
}
