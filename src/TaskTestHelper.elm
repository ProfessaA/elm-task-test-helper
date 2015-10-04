module TaskTestHelper where

{-| This module has utilities for inspecting tasks synchronously.
This should only be used in tests where you can ensure in test set up that all
tasks are synchronous.

# Helpers
@docs resultFromTask

-}

import Native.TaskTestHelper
import Task exposing (Task)


{-| Return a Maybe that is either Nothing if the given task involves
asynchronous operations, or Just a result containing the success or error value
of the task when synchronously executed.

For example:
```
resultFromTask (Http.get someDecoder "some-url")
```
will return Nothing, indicating that you have an unexpected async task in your task chain.

However,
```
resultFromTask (Task.succeed "a deserialized http response")
```
will return `Just (Ok "a deserialized http response")`

And
```
resultFromTask (Task.fail Http.NetworkError)
```
will return `Just (Err Http.NetworkError)`

-}
resultFromTask : Task a b -> Maybe (Result a b)
resultFromTask =
    Native.TaskTestHelper.resultFromTask
