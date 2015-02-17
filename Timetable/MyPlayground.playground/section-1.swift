
var dictionary = [String : [String : [Int]]]()


dictionary["hoge"] = ["fuga": [1]]

var hoge = "hoge"
var fuga = "fuga"

for i in dictionary[hoge]![fuga]! {
	println(i)
}

