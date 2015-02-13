// Playground - noun: a place where people can play

import Cocoa

var hoge : Int? = nil

if hoge == nil {
	println("Hello")
}

class Hoge {
	var hoge = "C"
}

func fuga(hoge : Hoge) {
	hoge.hoge = "B"
}

var h = Hoge()

fuga(h)

h.hoge





