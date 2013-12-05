// Create `window.describe` etc. for our BDD-like tests.
mocha.setup({ui: 'bdd'});

// Create another global variable for simpler syntax.
window.expect = chai.expect;

window.simplePerf= function(name, opts, actions) {
  if(arguments.length < 2) {
    throw "Not enough arguments for simplePerf";
  }
  if(arguments.length == 2) {
    actions= opts;
    opts= {};
  }
  var primer= opts.prime || 5000,
      timer= opts.times || 100000,
      label= name + " (x"+ timer +")";

  console.log( label );

  for (var stepName in actions) {
    var testFn= actions[stepName];

    for (var i = 0; i < primer; i++) {
        testFn();
    }

    console.time(stepName);
    for (var i = 0; i < timer; i++) {
         testFn();
    }
    console.timeEnd(stepName);
  }
}
