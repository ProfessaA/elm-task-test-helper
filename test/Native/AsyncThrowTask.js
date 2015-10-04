Elm.Native = Elm.Native || {};
Elm.Native.AsyncThrowTask = {};

Elm.Native.AsyncThrowTask.make = function(localRuntime) {
    "use strict";

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.AsyncThrowTask = localRuntime.Native.AsyncThrowTask || {};

    if (localRuntime.Native.AsyncThrowTask.values)
    {
          return localRuntime.Native.AsyncThrowTask.values;
    }


    var Task = Elm.Native.Task.make(localRuntime);

    function newTask() {
        return Task.asyncFunction(function() {
            throw "so you ran an async task...";
        });
    }

    return localRuntime.Native.AsyncThrowTask.values = {
        newTask: newTask()
    }
};
