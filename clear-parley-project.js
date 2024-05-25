// last modified 2024-05-25

// paste the following in the JS console to clear out the existing assignment in projects/

fs = require('fs');
function isDirectory(d) {
  try {
    let s = fs.statSync(d);
    return s.isDirectory();
  } catch (e) {
    return false;
  }
}
function rmDirectory(d, deldir) {
  let ff = fs.readdirSync(d);
  ff.forEach(function (f) {
    let df = d + '/' + f;
    if (isDirectory(df)) {
      rmDirectory(df, deldir);
    } else {
      fs.unlinkSync(df);
    }
  });
  if (deldir) { fs.rmdirSync(d); }
}
function rmPath(p, deldir) {
  if (isDirectory(p)) {
    rmDirectory(p, deldir);
  } else {
    fs.unlinkSync(p);
  }
}
function mvPath(p1, p2) {
  if (isDirectory(p1)) {
    let ff = fs.readdirSync(p1);
    ff.forEach(function (f) {
      if (!isDirectory(p2)) {
        fs.mkdirSync(p2);
      }
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

