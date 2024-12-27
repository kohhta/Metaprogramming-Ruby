# Q1.
#
# 問題の解説
# defだとSyntaxErrorになってしまうようなメソッド名でも、define_methodを使うことでメソッドとして定義することができます。
#
class A1
  define_method '//' do
    '//'
  end
end

# Q2
#
# 問題の解説
# define_singleton_method を利用して動的に特異メソッドを定義することで、条件2を満たしています。
# define_method は Module のインスタンスメソッドなので、initializeメソッド中では使えません。
# A2.define_methodのようにすれば使えますが、それだとA2クラスのインスタンスメソッドになるので
# すべてのA2インスタンスで利用できてしまい、
# 「メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない」
# という仕様を満たすことができません。
#
class A2
  def initialize(ary)
    ary.each do |name|
      method_name = "hoge_#{name}"

      define_singleton_method method_name do |times|
        if times.nil?
          dev_team
        else
          method_name * times
        end
      end
    end
  end

  def dev_team
    'SmartHR Dev Team'
  end
end

# Q3.
#
# 問題の解説
# 3章にはまだ登場していない概念ですが、included フックを利用してモジュールが include されたときの振る舞いを記述しています。
# my_attr_accessor メソッドはクラスメソッドに相当するため、included メソッドの引数として渡されてきたクラスに直接 define_singleton_method でメソッドを追加しています。
# さらに my_attr_accessor メソッド実行時にインスタンスメソッドを追加するために define_method を利用しています。
# セッターで定義した値を格納するために `@my_attr_accessor` をハッシュとして定義して利用しています。
# `?`つきのメソッドを定義するために、セッター実行時に define_aingleton_method でメソッドを追加しています。
#
module OriginalAccessor
  def self.included(base)
    base.define_singleton_method(:my_attr_accessor) do |attr|
      base.define_method attr do
        @my_attr_accessor&.fetch(attr) { nil }
      end

      base.define_method "#{attr}=" do |value|
        (@my_attr_accessor ||= {})[attr] = value

        if value.is_a?(TrueClass) || value.is_a?(FalseClass)
          define_singleton_method "#{attr}?" do
            !!value
          end
        end
      end
    end
  end
end
