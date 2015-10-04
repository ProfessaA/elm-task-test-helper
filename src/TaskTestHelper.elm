module TaskTestHelper where

import Native.TaskTestHelper
import Task exposing (Task)

resultFromTask : Task a b -> Maybe (Result a b)
resultFromTask =
    Native.TaskTestHelper.resultFromTask
