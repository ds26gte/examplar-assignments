// last modified 2023-09-14

// Load this in JS console to clear out existing assignment in projects 

fs = require('fs');
xx = fs.readdirSync('projects/chaffs');
xx.forEach((x) => fs.unlinkSync('projects/chaffs/' + x));
yy = fs.readdirSync('projects/wheats');
yy.forEach((x) => fs.unlinkSync('projects/wheats/' + x));
fs.unlinkSync('projects/test.arr');
