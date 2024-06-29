
// MARK: - CONFIG

const { v4: uuidv4 } = require('uuid');
const express = require('express');
const app = express();
const port = 8080;

const items = [
    { 
        name: "TURIA",
        price: 2.0,
        image: null, 
        category: "beers"
    },
    {
        name: "DAMM LEMON",
        price: 2.0,
        image: null, 
        category: "beers",   
    },
    {
        name: "FREE DAMM",
        price: 2.0,
        image: null,
        category: "beers"
    },
    {
        name: "ESTRELLA DAMM",
        price: 1.8,
        image: null, 
        category: "beers"
    },
    {
        name: "MAHOU",
        price: 1.8,
        image: null, 
        category: "beers"
    },
    {
        name: "DESPERADOS",
        price: 2.5,
        image: null, 
        category: "beers"
    },
    {
        name: "ALHAMBRA VERDE",
        price: 2.5,
        image: null, 
        category: "beers"
    },
    {
        name: "LADRÓN DE MANZANAS",
        price: 2.5,
        image: null,
        category: "beers"
    },
    {
        name: "1906 MILNUEVE",
        price: 2.5,
        image: null,
        category: "beers"
    },
    {
        name: "ESTRELLA GALICIA",
        price: 2.2,
        image: null,
        category: "beers"
    },
    {
        name: "VOLDAMM",
        price: 2.2,
        image: null,
        category: "beers"   
    },
    {
        name: "CUBATA BARATO",
        price: 6.0,
        image: null,
        category: "beers"
    },
    {
        name: "CUBATA CARO",
        price: 7.0,
        image: null,
        category: "beers"
    },
    {
        name: "CUBATA PREMIUM",
        price: 8.0,
        image: null, 
        category: "other"
    },
    {
        name: "TINTO DE VERANO",
        price: 4.0,
        image: null,
        category: "other"
    },
    {
        name: "VAQUERITO BARATO",
        price: 3,
        image: null, 
        category: "other"
    },
    {
        name: "VAQUERITO CARO",
        price: 5,
        image: null, 
        category: "other"
    },
    {
        name: "CHUPITO BARATO",
        price: 1.5,
        image: null, 
        category: "other"
    },
    {
        name: "CHUPITO CARO",
        price: 2.0,
        image: null, 
        category: "other"
    },
    {
        name: "CHUPITO PREMIUM",
        price: 3.0,
        image: null,
        category: "other"
    },
    {   
        name: "AGUA",
        price: 1.5,
        image: null,
        category: "other"
    },
    {
        name: "AGUA CON GAS",
        price: 2.0,
        image: null,
        category: "other"
    },
    {
        name: "REDBULL",
        price: 2.0,
        image: null,
        category: "other"
    },
    {
        name: "VERMOUTH",
        price: 3.0,
        image: null,
        category: "other"
    },
    {
        name: "ZUMO",
        price: 1.5,
        image: null,
        category: "other"
    },
    {
        name: "COPA DE VINO",
        price: 3.0,
        image: null,
        category: "other"
    },
    {
        name: "BOTELLA FUENTESECA",
        price: 12.0,
        image: null,
        category: "other"
    },
    {
        name: "BOTELLA BOYANTE",
        price: 12.0,
        image: null,
        category: "other"
    },
    {
        name: "BOTELLA NOVIO PERFECTO",
        price: 14.0,
        image: null,
        category: "other"
    }
]

const emptyRows = items.map(function(item) {
    return {
        orderedQuantity: 0,
        paidQuantity: 0,
        item: item,
    };
});
const bills = [{ 
    id: uuidv4().toUpperCase(),
    name: "EN EL MOMENTO", 
    createdDate: (new Date).toISOString(),
    rows: emptyRows,
    historicActions: []
}]

app.use(express.json());

// MARK: - GET

app.get("/bills/", (req, res) => {
    res.status(200).send(bills);
})

app.get("/bills/:id", (req, res) => {
    const id = req.params.id;

    const bill = bills.find(bill => bill.id == id);
    if (!bill) {
        return res.status(404).send("No se encuentra la cuenta!");
    }
    res.status(200).send(bill);
})

// MARK: - POST

app.post("/bills", (req, res) => {
    const name = req.body.name;

    if (!name) {
        return res.status(400).send({ message: "Por favor, añade el nombre de la cuenta" });
    }

    const rows = items.map(function(item) {
        return {
            orderedQuantity: 0,
            paidQuantity: 0,
            item: item,
        };
    });

    const bill = { 
        id: uuidv4().toUpperCase(),
        name: name, 
        createdDate: (new Date).toISOString(),
        rows: rows,
        historicActions: []
    };
    bills.push(bill);
    res.status(201).send(bill);
});

// MARK: - PATCH

// Ruta PATCH para actualizar orderedQuantity
app.patch('/bills/:id', (req, res) => {
    const billId = req.params.id;
    const name = req.body.name;
    const rows = req.body.rows;
  
    var bill = bills.find(bill => bill.id == billId);

    if (!bill) {
        return res.status(404).send({ message: 'Bill not found' });
      }

    if (name) {
        bill.name = name
    }

    if (rows) {
        let action;
        rows.forEach((row, index) =>  {
            if (row.orderedQuantity > bill.rows[index].orderedQuantity) {
                action = {
                    date: (new Date).toISOString(),
                    action: "add",
                    detail: [{
                        itemName : row.item.name,
                        quantity: 1
                    }]
                };
            } else if (row.orderedQuantity < bill.rows[index].orderedQuantity) {
                action = {
                    date: (new Date).toISOString(),
                    action: "delete",
                    detail: [{
                        itemName : row.item.name,
                        quantity: 1
                    }]
                };
            } else if (row.paidQuantity > bill.rows[index].paidQuantity) {
                if (action == undefined) {
                    action = {
                        date: (new Date).toISOString(),
                        action: "charge",
                        detail: [{
                            itemName : row.item.name,
                            quantity: row.paidQuantity - bill.rows[index].paidQuantity
                        }]
                    };
                } else {
                    action.detail.push({
                        itemName: row.item.name,
                        quantity: row.paidQuantity - bill.rows[index].paidQuantity
                    });
                }
            }
        });
        if (action != undefined) {
            bill.historicActions.push(action);
        }
       
        bill.rows = rows
    }

    return res.status(200).send(bill);
});

// MARK: - LISTEN

app.listen(port, () => console.log('Server up!'));

