module TaskTestHelperTest where


import ElmTest.Assertion exposing (..)
import ElmTest.Test as Test exposing (Test, test)

import TaskTestHelper exposing (..)
import Task exposing (Task, andThen)
import Helpers.AsyncThrowTask as AsyncThrowTask


suite : Test
suite =
    Test.suite "TaskTestHelper Suite"
        [ syncSuccessTest
        , syncErrorTest
        , asyncRootTest
        , asyncInSuccessCallbackTest
        ] 


syncSuccessTest : Test
syncSuccessTest =
    test "it returns Just an Ok result when the task is synchronous and successful" <|
        assertEqual

            (Just (Ok "yolo"))

            (resultFromTask
                (Task.succeed "yo"
                |> Task.map (++)
                |> Task.map ((|>) "lo")
                |> Task.mapError (++)
                |> Task.mapError ((|>) "... no")))


syncErrorTest : Test
syncErrorTest =
    test "it returns Just an Err result when the task is synchronous and fails" <|
        assertEqual

            (Just (Err "yo... no"))

            (resultFromTask
                (Task.fail "yo"
                |> Task.map (++)
                |> Task.map ((|>) "lo")
                |> Task.mapError (++)
                |> Task.mapError ((|>) "... no")))


asyncRootTest : Test
asyncRootTest =
    test "it returns nothing when an async task is the root" <|
        assertEqual

            Nothing

            (resultFromTask
                (AsyncThrowTask.newTask
                |> Task.map ((++) "you'll never see this")
                |> Task.mapError ((++) "or this")))


asyncInSuccessCallbackTest : Test
asyncInSuccessCallbackTest =
    test "it returns nothing when a success chain contains an async task" <|
        assertEqual
            
            Nothing

            (resultFromTask
                ((Task.succeed "yo"
                 |> Task.map (++)
                 |> Task.map ((|>) "lo")
                 |> Task.mapError (++)
                 |> Task.mapError ((|>) "... no"))
                    `andThen` (always AsyncThrowTask.newTask)))
