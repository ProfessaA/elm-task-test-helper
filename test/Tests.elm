module Tests where

import ElmTest.Assertion exposing (..)
import ElmTest.Test exposing (..)

import String
import TaskTestHelperTest


all : Test
all =
    suite "All Tests"
        [
            TaskTestHelperTest.suite
        ]
