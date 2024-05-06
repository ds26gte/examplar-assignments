// last modified 2024-05-06

// paste the following in the JS console to clear out the existing assignment in projects/

fs = require('fs');
function isDirectory(d) {
  let s = fs.statSync(d);
  return s.isDirectory();
}
function rmDirectory(d) {
  let ff = fs.readdirSync(d);
  ff.forEach(function (f) {
    let df = d + '/' + f;
    if (isDirectory(df)) {
      rmDirectory(df);
      fs.rmdirSync(df);
    } else {
      fs.unlinkSync(df);
    }
  });
}
function rmPath(p) {
  if (isDirectory(p)) {
    rmDirectory(p);
    fs.rmdirSync(p);
  } else {
    fs.unlinkSync(p);
  }
}
function mvPath(p1, p2) {
  if (isDirectory(p1)) {
    let ff = fs.readdirSync(p1);
    ff.forEach(function (f) {
      mvPath(p1 + '/' + f, p2 + '/' + f);
    });
  } else {
    fs.renameSync(p1, p2);
  }
}



rmPath('projects/chaffs')
rmPath('projects/wheats')
rmPath('projects/test.arr')
rmPath('projects/hints.json')



