# library.local
a portable digital library that creates a local wifi network for sharing critical tech theory, zines, and essays. created for [solidarity infastructures](https://infrastructures.us/) winter '25 session @ the [school for poetic comptuation](https://sfpc.study/).

a quiet space for critical reading, hosted on your own raspberry pi. share your curated collection of books, zines, and essays with friends and family through a simple wifi network.

> 💡 this project helps you create a personal library website that's accessible offline. when someone connects to your wifi network, they'll see your collection of reading materials.

---

## quick start

1. **get the code**
   ```bash
   git clone https://github.com/naestech/library.local.git
   cd library.local
   ```

2. **follow the guide**
   read [piguide.md](piguide.md) for step-by-step instructions on setting up your library.

3. **customize your library**
   edit `index.html` to add your books, zines, and essays. you can find the template [here](index.html).

---

## what's included

* 📚 **website template**: a clean, simple interface for your library
* 📡 **wifi access point**: creates a network named "library.local"
* 🔒 **captive portal**: automatically shows your library when someone connects
* 📱 **mobile-friendly**: works great on phones and tablets

---

## project structure

```
library.local/
├── pdfs/              
│   └── example-book.pdf
│   └── example-zine.pdf
│   └── example-essay.pdf
├── scripts/          
│   └── start-library.sh
├── index.html       
├── blog.md          
├── piguide.md  
├── README.md 
├──.gitattributes   
└── .gitignore        
```

---

## contributing

found a bug? have an idea to make this better? [open an issue](https://github.com/naestech/library.local/issues)


---

happy reading and sharing! 📚
