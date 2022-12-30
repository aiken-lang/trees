//// A binary search tree

pub type Tree<data> {
  Empty

  Node { data: data, left: Tree<data>, right: Tree<data> }
}

pub type Ordering {
  Less
  Greater
  Equal
}

pub fn empty() -> Tree<data> {
  Empty
}

pub fn leaf(data: data) -> Tree<data> {
  Node { data, left: Empty, right: Empty }
}

pub fn insert(
  tree: Tree<data>,
  data new_data: data,
  cmp: fn(data, data) -> Ordering,
) -> Tree<data> {
  when tree is {
    Empty -> leaf(new_data)
    Node { data, left, right } ->
      when cmp(new_data, data) is {
        Less -> Node { data, left: insert(left, new_data, cmp), right }
        Greater -> Node { data, left, right: insert(right, new_data, cmp) }
        Equal -> tree
      }
  }
}

fn compare_int(a: Int, b: Int) -> Ordering {
  if a < b {
    Less
  } else if a > b {
    Greater
  } else {
    Equal
  }
}

test insert_1() {
  let fixture = Node { data: 4, left: leaf(2), right: leaf(7) }

  let result =
    Empty
    |> insert(4, compare_int)
    |> insert(7, compare_int)
    |> insert(2, compare_int)

  result == fixture
}

pub fn find(
  in tree: Tree<data>,
  item: data,
  cmp: fn(data, data) -> Ordering,
) -> Option<data> {
  when tree is {
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

  let found = find(tree, 7, compare_int)

  found == Some(7)
}

test find_2() {
  let tree = Node { data: 4, left: leaf(2), right: leaf(7) }

  let not_found = find(tree, 10, compare_int)

  not_found == None
}
