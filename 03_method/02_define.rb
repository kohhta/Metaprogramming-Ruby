# Q1.
# 次の動作をする A1 class を実装する
# - "//" を返す "//"メソッドが存在すること
class A1
  define_method "//" do
    "//"
  end
end

# Q2.
# 次の動作をする A2 class を実装する
# - 1. "SmartHR Dev Team"と返すdev_teamメソッドが存在すること
# - 2. initializeに渡した配列に含まれる値に対して、"hoge_" をprefixを付与したメソッドが存在すること
# - 2で定義するメソッドは下記とする
#   - 受け取った引数の回数分、メソッド名を繰り返した文字列を返すこと
#   - 引数がnilの場合は、dev_teamメソッドを呼ぶこと
# - また、2で定義するメソッドは以下を満たすものとする
#   - メソッドが定義されるのは同時に生成されるオブジェクトのみで、別のA2インスタンスには（同じ値を含む配列を生成時に渡さない限り）定義されない
class A2
  def initialize(name_array)
    name_array.each do |name|
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
# 次の動作をする OriginalAccessor モジュール を実装する
# - OriginalAccessor モジュールは include されたときのみ my_attr_accessor メソッドを定義すること
# - my_attr_accessor は getter / setter に加えて、boolean 値 を代入した際のみ真偽値判定を行う accessor と同名の ? メソッドができること
module OriginalAccessor
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def my_attr_accessor(*attrs)
      attrs.each do |attr|
        # getter
        define_method(attr) do
          instance_variable_get("@#{attr}")
        end

        # setter
        define_method("#{attr}=") do |value|
          instance_variable_set("@#{attr}", value)
        end

        # boolean accessor
        define_method("#{attr}?") do
          !!instance_variable_get("@#{attr}")
        end
      end
    end
  end
end
