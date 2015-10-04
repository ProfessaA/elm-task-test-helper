module Helpers.AsyncThrowTask
    ( newTask
    ) where


import Native.AsyncThrowTask
import Task exposing (Task)


newTask : Task String String
newTask =
    Native.AsyncThrowTask.newTask
