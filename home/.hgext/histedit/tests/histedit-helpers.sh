#!/bin/sh

fixbundle() {
    grep -v 'saving bundle' | grep -v 'saved backup' | grep -v added | grep -v adding
}