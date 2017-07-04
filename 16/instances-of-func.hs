{-# LANGUAGE ViewPatterns #-}

import Test.QuickCheck
import Test.QuickCheck.Function

functorIdentity :: (Functor f, Eq (f a)) => f a -> Bool
functorIdentity f = fmap id f == f

functorCompose' :: (Eq (f c), Functor f) => f a -> Fun a b -> Fun b c -> Bool
functorCompose' x (Fun _ f) (Fun _ g) = (fmap (g . f) x) == (fmap g . fmap f $ x)

type IntToInt = Fun Int Int
type IntFC = [Int] -> IntToInt -> IntToInt -> Bool

-----------------------------
-- 1.
-----------------------------
newtype Identity a = Identity a deriving (Eq, Show)

instance Functor Identity where
  fmap f (Identity a) = Identity (f a)

instance Arbitrary a => Arbitrary (Identity a) where
  arbitrary = do
    a <- arbitrary
    return (Identity a)

type IdentityIdentity = Identity Int -> Bool
type IdentityCompose = IntFC

-----------------------------
-- 2.
-----------------------------
data Pair a = Pair a a deriving (Eq, Show)

instance Functor Pair where
  fmap f (Pair x y) = Pair (f x) (f y)

instance Arbitrary a => Arbitrary (Pair a) where
  arbitrary = do
    a <- arbitrary
    return (Pair a a)

type PairIdentity a = Pair a -> Bool
type PairCompose = IntFC

-----------------------------
-- 3.
-----------------------------
data Two a b = Two a b deriving (Eq, Show)

instance Functor (Two a) where
  fmap f (Two x y) = Two x (f y)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Two a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    return (Two a b)

type TwoIdentity a b = Two a b -> Bool
type TwoCompose = IntFC

-----------------------------
-- 4.
-----------------------------
data Three a b c = Three a b c deriving (Eq, Show)

instance Functor (Three a b) where
  fmap f (Three x y z) = Three x y (f z)

instance (Arbitrary a, Arbitrary b, Arbitrary c) => Arbitrary (Three a b c) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    c <- arbitrary
    return (Three a b c)

type ThreeIdentity a b c = Three a b c -> Bool
type ThreeCompose = IntFC

-----------------------------
-- 5.
-----------------------------
data Three' a b = Three' a b b deriving (Eq, Show)

instance Functor (Three' a) where
  fmap f (Three' x y z) = Three' x (f y) (f z)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Three' a b) where
  arbitrary = do
    a <- arbitrary
    b <- arbitrary
    return (Three' a b b)

type Three'Identity a b = Three' a b -> Bool
type Three'Compose = IntFC

-----------------------------
-- 6.
-----------------------------
data Four a b c d = Four a b c d deriving (Eq, Show)

instance Functor (Four a b c) where
  fmap f (Four w x y z) = Four w x y (f z)

instance (Arbitrary a, Arbitrary b, Arbitrary c, Arbitrary d) => Arbitrary (Four a b c d) where
  arbitrary = do
    w <- arbitrary
    x <- arbitrary
    y <- arbitrary
    z <- arbitrary
    return (Four w x y z)

type FourIdentity a b c d = Four a b c d -> Bool
type FourCompose = IntFC

-----------------------------
-- 7.
-----------------------------
data Four' a b = Four' a a a b deriving (Eq, Show)

instance Functor (Four' a) where
  fmap f (Four' w x y z) = Four' w x y (f z)

instance (Arbitrary a, Arbitrary b) => Arbitrary (Four' a b) where
  arbitrary = do
    x <- arbitrary
    y <- arbitrary
    return (Four' x x x y)

type Four'Identity a b = Four' a b -> Bool
type Four'Compose = IntFC

-----------------------------
-- 8.
-----------------------------
data Trivial = Trivial

-- Trivial is of kind * and cannot be an instance of Functor

main :: IO ()
main = do
  putStrLn "\n1."
  quickCheck (functorIdentity :: IdentityIdentity)
  quickCheck (functorCompose' :: IdentityCompose)

  putStrLn "\n2."
  quickCheck (functorIdentity :: PairIdentity Int)
  quickCheck (functorCompose' :: PairCompose)

  putStrLn "\n3."
  quickCheck (functorIdentity :: TwoIdentity Int Int)
  quickCheck (functorCompose' :: TwoCompose)

  putStrLn "\n4."
  quickCheck (functorIdentity :: ThreeIdentity Int Int Int)
  quickCheck (functorCompose' :: ThreeCompose)

  putStrLn "\n5."
  quickCheck (functorIdentity :: Three'Identity Int Int)
  quickCheck (functorCompose' :: Three'Compose)

  putStrLn "\n6."
  quickCheck (functorIdentity :: FourIdentity Int Int Int Int)
  quickCheck (functorCompose' :: FourCompose)

  putStrLn "\n7."
  quickCheck (functorIdentity :: Four'Identity Int Int)
  quickCheck (functorCompose' :: Four'Compose)

