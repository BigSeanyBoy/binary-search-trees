# frozen_string_literal: true

# The Node class represents elements of the Tree
class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data, left, right)
    @data = data
    @left = left
    @right = right
  end

  def no_children?
    @left.nil? && right.nil?
  end

  def <=>(other)
    @data <=> other.data
  end
end

# The Tree class represents the Binary Search Tree
class Tree
  def initialize(ary)
    @data = ary.sort.uniq
    @root = build_tree(@data)
  end

  def build_tree(ary)
    mid = (0 + (ary.length - 0)) / 2
    left = ary.length == 1 ? nil : build_tree(ary[0...mid])
    right = ary.length <= 2 ? nil : build_tree(ary[mid + 1...ary.length])

    Node.new(ary[mid], left, right)
  end

  def insert(value, node = @root)
    return nil if value == node.data

    if value < node.data
      node.left.nil? ? node.left = Node.new(value, nil, nil) : insert(value, node.left)
    else
      node.right.nil? ? node.right = Node.new(value, nil, nil) : insert(value, node.right)
    end
  end

  def delete(value, node = @root)
    if value < node
      node.left = delete(value, node.left)
    elsif value > node
      node.right = delete(value, node.right)
    else
      return nil if node.nil? || node.no_children?

      return node.left if node.right.nil?

      node.data = min_value_node(node.right).data
      node.right = delete(node.data)
    end
    node
  end

  def min_value_node(node = @root)
    node = node.left until node.left.nil?
    node
  end

  def find(value, node = @root)
    return node if node.nil? || node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def level_order(node = @root, queue = [])
    print("#{node.data} ")
    queue.push(node.left) unless node.left.nil?
    queue.push(node.right) unless node.right.nil?
    return if queue.empty?

    level_order(queue.shift, queue)
  end

  def inorder(node = @root)
    return nil if node.nil?

    inorder(node.left)
    print("#{node.data} ")
    inorder(node.right)
  end

  def preorder(node = @root)
    return nil if node.nil?

    print("#{node.data} ")
    inorder(node.left)
    inorder(node.right)
  end

  def postorder(node = @root)
    return nil if node.nil?

    inorder(node.left)
    inorder(node.right)
    print("#{node.data} ")
  end

  def height(node = @root)
    return 0 if node.nil? || node == @root

    [height(node.left), height(node.right)].max +  1
  end

  def depth(node = @root, parent = root, edges = 0)
    return 0 if node == parent
    return -1 if parent.nil?

    if node < parent
      edges += 1
      depth(node, parent.left, edges)
    elsif node > parent
      edges += 1
      depth(node, parent.right, edges)
    else
      edges
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    return false unless (height(node.left) - height(node.right)).abs <= 1

    return false unless balanced?(node.left) && balanced?(node.right)

    true
  end

  def rebalance
    @data = node_array
    @root = build_tree(@data)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def node_array(node = @root, array = [])
    unless node.nil?
      node_array(node.left, array)
      array.push(node.data)
      node_array(node.right, array)
    end
    array
  end
end

# Driver script

array = Array.new(15) { rand(1..100) }
bst = Tree.new(array)

bst.pretty_print

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder

10.times do
  a = rand(100..150)
  bst.insert(a)
  puts "Inserted #{a} to tree."
end

bst.pretty_print

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Rebalancig tree...'
bst.rebalance

bst.pretty_print

puts bst.balanced? ? 'Your Binary Search Tree is balanced.' : 'Your Binary Search Tree is not balanced.'

puts 'Level order traversal: '
puts bst.level_order

puts 'Preorder traversal: '
puts bst.preorder

puts 'Inorder traversal: '
puts bst.inorder

puts 'Postorder traversal: '
puts bst.postorder
