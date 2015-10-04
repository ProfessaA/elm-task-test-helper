Elm.Native.TaskTestHelper = {};
Elm.Native.TaskTestHelper.make = function(localRuntime) {
    "use strict";

    localRuntime.Native = localRuntime.Native || {};
    localRuntime.Native.TaskTestHelper = localRuntime.Native.TaskTestHelper || {};
    if (localRuntime.Native.TaskTestHelper.values)
    {
          return localRuntime.Native.TaskTestHelper.values;
    }


    var Maybe = Elm.Maybe.make(localRuntime);
    var Result = Elm.Result.make(localRuntime);
    var Task = Elm.Native.Task.make(localRuntime);

    var FoundAsyncErr = "found async task in callback chain";

    function isAsynchronous(task) {
        var tag = task.tag;

        if (tag === 'Async') {
            return true;
        }

        if (tag === 'AndThen' || tag === 'Catch') {
            return isAsynchronous(task.task);
        }

        return false;
    }


    function makeCallbacksThrowWhenAsyncEncountered(task) {
        var tag = task.tag;

        if (tag === 'AndThen' || tag === 'Catch') {
            var originalCallback = task.callback;

            task.callback = function() {
                var args = Array.prototype.slice.call(arguments);
                var nextTask = originalCallback.apply(originalCallback, args)

                if (isAsynchronous(nextTask) === true) {
                    throw FoundAsyncErr;
                }

                return nextTask;
            }

            makeCallbacksThrowWhenAsyncEncountered(task.task);
        }
    }


    function resultFromTask(task) {
        if (isAsynchronous(task) === true) {
            return Maybe.Nothing;
        }


        makeCallbacksThrowWhenAsyncEncountered(task);


        var successValue;
        task = A2(Task.andThen, task, function(value) {
            successValue = value;
            return Task.succeed(value)
        });

        var errorValue;
        task = A2(Task.catch_, task, function(value) {
            errorValue = value;
            return Task.fail(value)
        });


        try {
            Task.perform(task);
        }
        catch (e) {
            if (e ===  FoundAsyncErr) {
                return Maybe.Nothing;
            }
            else {
                throw e;
            }
        }


        if (successValue !== undefined) {
            return Maybe.Just(Result.Ok(successValue));
        }
        else if (errorValue !== undefined) {
            return Maybe.Just(Result.Err(errorValue));
        }

        return Maybe.Nothing;
    }


    return localRuntime.Native.TaskTestHelper.values = {
        resultFromTask: resultFromTask
    }
};
