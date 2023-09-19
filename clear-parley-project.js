// last modified 2023-09-19

// paste the following in the JS console to clear out the existing assignment in projects/

fs = require('fs');
xx = fs.readdirSync('projects/chaffs');
xx.forEach((x) => fs.unlinkSync('projects/chaffs/' + x));
yy = fs.readdirSync('projects/wheats');
yy.forEach((x) => fs.unlinkSync('projects/wheats/' + x));
fs.unlinkSync('projects/test.arr');
