//// A binary search tree

use aiken/int

pub opaque type Tree<data> {
  Empty
  Node { data: data, left: Tree<data>, right: Tree<data> }
}

pub fn empty() -> Tree<data> {
  Empty
}

pub fn leaf(data: data) -> Tree<data> {
  Node { data, left: Empty, right: Empty }
}

pub fn insert(
  self: Tree<data>,
  data new_data: data,
  cmp: fn(data, data) -> Ordering,
) -> Tree<data> {
  when self is {
    Empty -> leaf(new_data)
    Node { data, left, right } ->
      when cmp(new_data, data) is {
        Less -> Node { data, left: insert(left, new_data, cmp), right }
        Greater -> Node { data, left, right: insert(right, new_data, cmp) }
        Equal -> self
      }
  }
}

test insert_1() {
  let fixture = Node { data: 4, left: leaf(2), right: leaf(7) }

  let result =
    empty()
    |> insert(4, int.compare)
    |> insert(7, int.compare)
    |> insert(2, int.compare)

  result == fixture
}

pub fn find(
  self: Tree<data>,
  item: data,
  cmp: fn(data, data) -> Ordering,
) -> Option<data> {
  when self is {
    Empty -> None
    Node { data, left, right } ->
      when cmp(item, data) is {
        Less -> find(left, item, cmp)
        Greater -> find(right, item, cmp)
        Equal -> Some(data)
      }
  }
}

test find_1() {
  let tree = Node { data: 4, left: leaf(2), right: leaf(7) }
  let found = find(tree, 7, int.compare)
  found == Some(7)
}

test find_2() {
  let tree = Node { data: 4, left: leaf(2), right: leaf(7) }
  let not_found = find(tree, 10, int.compare)
  not_found == None
}
