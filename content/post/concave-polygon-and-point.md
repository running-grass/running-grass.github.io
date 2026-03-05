---
title: "凹多边形和点的位置问题(凹包问题面对对象的算法)"
date: 2016-08-01
lastmod: 2024-02-01
draft: false
aliases:
  - /post/concave-polygon-and-point
---

已知一个任意多边形的各顶点坐标，任意给一点坐标，判断是否在该多边形内部或边线上, 这只是一个笨拙的实现

<!--more-->

github链接: <https://github.com/running-grass/phptools.git>

composer: `composer require "leo1992/tools:^0"`


## 问题描述 {#问题描述}

已知一个任意多边形的各顶点坐标，任意给一点坐标，判断是否在该多边形内部或边线上


## 解决思路及基础 {#解决思路及基础}

1.  任意凸多边形中，经过任一顶点连接各个顶点，可以把多边形分割为多个三角形
2.  任意三角形中一点，和三条边上面各两个顶点的夹角共六个，如果该点在三角形内部，六个角之和等于180度，否则在三角形外部
3.  任意凹多边形都可以转化为，任一凸多边形减去N个三角形
4.  在上一条件下，如果一个点在这个大的凸多边形中（包括边），但不在去掉的N个三角形中（不包括边界），则该点在该凹多边形中
5.  一个点如果和线段的两个顶点连接形成的两个夹角和等于180°，则该点在线段上
6.  把凹多边形的问题细化到点和三角形以及点和线段的位置关系


## 实现部分 {#实现部分}

1.  设计了六个类，点、线段、角、三角形、凸多边形、多边形
2.  其中三角形继承凸多边形，凸多边形继承多边形类


### 1.Point（点类） {#1-dot-point-点类}

这个类主要保存点信息，没有任何操作

```php
// 点类
class Point extends Base
{
    private $x; // x坐标
    private $y; // y 坐标

    public function __construct($x, $y)
    {
        try {
            $this->setX($x);
            $this->setY($y);

            unset($x, $y);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setX($x)
    {
        try {
            $this->x = (float)$x;

            unset($x);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getX()
    {
        try {
            return $this->x;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setY($y)
    {
        try {
            $this->y = (float)$y;

            unset($y);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getY()
    {
        try {
            return $this->y;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    public function __toString()
    {
        try {
            return "({$this->getX()},{$this->getY()})";
        } catch (\Exception $e) {
            throw $e;
        }
    }

}
```


### 2.Line(线段) {#2-dot-line--线段}

这个类由两个点构成，提供一个操作来判断某点是否在线段上

```php
 class Line extends Base
{
    private $p1;     // 线段第一个点
    private $p2;     // 线段的第二个点
    private $tilt;   // 倾斜角，距x轴正方向的逆时针角度
    private $length; // 线段的长度

    public function __construct(Point $p1, Point $p2)
    {
        try {
            // 两个端点不能重合，没长度
            if ($p1 == $p2) {
                throw new TwoPointOverlapException('两个端点不能重合');
            }
            $this->setP1($p1);
            $this->setP2($p2);
            unset($p1, $p2);
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 生成线段的长度
    private function generateLength()
    {
        try {
            // 利用勾股定理
            $length = sqrt(pow($this->getP1()->getX() - $this->getP2()->getX(), 2) +
                           pow($this->getP1()->getY() - $this->getP2()->getY(), 2));
            $this->setLength(abs($length));
            unset($length);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 生成倾斜角
    private function generateTilt()
    {
        try {
            $dy = $this->getP2()->getY() - $this->getP1()->getY();
            $dx = $this->getP2()->getX() - $this->getP1()->getX();

            // 不同的象限不同处理，dx为零的情况单独处理
            if ($dx > 0 && $dy >= 0) {
                $ang = (rad2deg(atan($dy/$dx)));
                $ext = 0;
            } elseif ($dx <= 0 && $dy >= 0) {
                if (0 == $dx) {
                    $ang = 0;
                    $ext = 90;
                } else {
                    $ang = (rad2deg(atan($dy/$dx)));
                    $ext = 180;
                }
            } elseif ($dx < 0 && $dy <= 0) {
                $ang = (rad2deg(atan($dy/$dx)));
                $ext = 180;
            } elseif ($dx >= 0 && $dy < 0) {
                if (0 == $dx) {
                    $ang = 0;
                    $ext = 270;
                } else {
                    $ang = (rad2deg(atan($dy/$dx)));
                    $ext = 360;
                }
            }
            $ang = $ang + $ext;
            $this->setTilt($ang);

            unset($dx, $dy, $ang, $ext);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 判断点是否在线上
    public function inLine(Point $p)
    {
        try {
            $l1 = new Line($p, $this->getP1());
            $l2 = new Line($p, $this->getP2());
            $is = false;
            // 这个点和这条线段的两个端点生成的两条线的倾斜角要互补
            if (180 == abs($l1->getTilt() - $l2->getTilt())) {
                $is = true;
            } else {
                $is = false;
            }

            unset($l1, $l2);
            return $is;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setP1(Point $p1)
    {
        try {
            $this->p1 = $p1;
            unset($p1);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP1()
    {
        try {
            return $this->p1;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setP2(Point $p2)
    {
        try {
            $this->p2 = $p2;
            unset($p2);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP2()
    {
        try {
            return $this->p2;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setTilt($tilt)
    {
        try {
            $this->tilt = (float)$tilt;
            unset($tilt);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getTilt()
    {
        try {
            if (empty($this->generateTilt)) {
                $this->generateTilt();
            }
            return $this->tilt;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setLength($length)
    {
        try {
            $this->length = (float)$length;
            unset($length);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getLength()
    {
        try {
            if (empty($this->length)) {
                $this->generateLength();
            }
            return $this->length;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    public function __toString()
    {
        try {
            return '[' . (string)$this->getP1() . '->' . (string)$this->getP2() . ']';
        } catch (\Exception $e) {
            throw $e;
        }
    }
}
```


### 3.Angle（角） {#3-dot-angle-角}

角类由两条线段构成，提供返回夹角的操作

```php
     // 角度类
class Angle extends Base
{
    private $l1;
    private $l2;
    private $angle;

    public function __construct(Line $l1, Line $l2)
    {
        try {
            if ($l1->getP2() != $l2->getP1()) {
                throw new \Exception('两条线段不是首尾相连');
            }
            // 会引起错误
            // if (360 == ($l1->getTilt() + $l2->getTilt())) {
                // throw new LineOverlapException('两条线段不能重叠');
            // }
            $this->setL1($l1);
            $this->setL2($l2);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    private function generateAngle()
    {
        try {
            $angle =  $this->getL1()->getTilt() - $this->getL2()->getTilt() + 180;
            $angle = fmod(($angle + 360),360);
            $this->setAngle($angle);
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    public function setL1(Line $l1)
    {
        try {
            $this->l1 = $l1;
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getL1()
    {
        try {
            return $this->l1;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    public function setP(Point $p)
    {
        try {
            $this->p = $p;
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP()
    {
        try {
            return $this->p;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    public function setL2(Line $l2)
    {
        try {
            $this->l2 = $l2;
            return 0;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getL2()
    {
        try {
            return $this->l2;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setAngle($angle)
    {
        try {
            $this->angle = $angle;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getAngle()
    {
        try {
            if (empty($this->angle)) {
                $this->generateAngle();
            }
            return $this->angle;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    public function __toString()
    {
        try {
            return '{' . (string)$this->getL1() . '=>' . (string)$this->getL2() . '}';
        } catch (\Exception $e) {
            throw $e;
        }
    }

}
```


### 4.Polygon（多边形） {#4-dot-polygon-多边形}

由一组相邻不重复的点构成，提供一个操作用来判断点是否在多边形内部

如果是凹多边形，把多边形中内角为优角的点去掉一个，用剩下的点构成一个多边形，记录下由此补上的三角形

如果依然是凹多边形，继续去掉一个凹点，把补上的三角形记录下来

最后会得到一个凸多边形和一组补上的三角形，

对凸多边形和三角形集合分别求解，

在凸多边形内而不在三角形集合中的点则在凹多边形内部，否则在外部

```php
// 矩形类
class Triangle extends ConvexPolygon
{
    private $p1;
    private $p2;
    private $p3;

    public function __construct(Point $p1, Point $p2, Point $p3)
    {
        try {
            $this->setP1($p1);
            $this->setP2($p2);
            $this->setP3($p3);

            $arr = [
                $this->getP1(),
                $this->getP2(),
                $this->getP3()
            ];
            parent::__construct($arr);
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 判断一个点是否在矩形内
    public function inTriangle(Point $p)
    {
        try {
            $p1 = $this->getP1();
            $p2 = $this->getP2();
            $p3 = $this->getP3();

            $ls = $this->getLines();

            $l1 = new Line($p, $p1);
            $l2 = new Line($p, $p2);
            $l3 = new Line($p, $p3);

            $a1 = (new Angle($l1, $ls[0]))->getAngle();
            $a2 = (new Angle($l2, $ls[1]))->getAngle();
            $a3 = (new Angle($l3, $ls[2]))->getAngle();

            // $t = new Angle($l3, $ls[2]);
            // dump($t);
            // dump($t->getAngle());

            $l1 = new Line($p1, $p);
            $l2 = new Line($p2, $p);
            $l3 = new Line($p3, $p);

            $b1 = (new Angle($ls[2], $l1))->getAngle();
            $b2 = (new Angle($ls[0], $l2))->getAngle();
            $b3 = (new Angle($ls[1], $l3))->getAngle();


            // $as  = $tri->getAngles();
            // foreach ($as as $a) {
            //     dump($a->getAngle());
            // }

            // dump($this);
            // dump("$a1/ $a2/ $a3/ $b1/ $b2/ $b3");
            // die;

            $c = $a1 + $a2 + $a3 + $b1 + $b2 + $b3;


            $is = false;
            if (180 >= (int)$c) {
                $is = true;
            } else {
                $is = false;
            }
            return $is;
        } catch (LineOverlapException $e) {
            return true;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setP1(Point $p1)
    {
        try {
            $this->p1 = $p1;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP1()
    {
        try {
            return $this->p1;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setP2(Point $p2)
    {
        try {
            $this->p2 = $p2;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP2()
    {
        try {
            return $this->p2;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    // setting and  getting
    private function setP3(Point $p3)
    {
        try {
            $this->p3 = $p3;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP3()
    {
        try {
            return $this->p3;
        } catch (\Exception $e) {
            throw $e;
        }
    }
}
```


### 5. ConvexPolygon（凸多边形） {#5-dot-convexpolygon-凸多边形}

因为凸多边形可以被分割成N个三角形，所有只要判断是否在三角形集合内就可以确定是否在凸多边形内

```nil

// 凸多边形类
class ConvexPolygon extends Polygon
{
    private $triangles;

    public function __construct(array $arr_point)
    {
        try {
            parent::__construct($arr_point);
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 判断是否在凸多边形内
    public function inConvexPolygon(Point $p)
    {
        try {
            $arr_tri = $this->getTriangles();
            $is = false;
            foreach ($arr_tri as $tri) {
                if ($tri->inTriangle($p)) {
                    $is = true;
                    break;
                }

                // // dump("判断凸多边形".(int)$is);
                // $as  = $tri->getAngles();
                // foreach ($as as $a) {
                //     dump($a->getAngle());
                // }

            }
            return $is;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 生成三角形集合
    private function generateTriangles()
    {
        try {
            $num = $this->getNumber();
            $ps = $this->getPoints();
            $p0 = $ps[0];
            unset($ps[0]);
            for ($i = 1; $i < $num - 1; $i++) {
                $arr[] = new Triangle($p0, $ps[$i], $ps[$i+1]);
            }
            $this->setTriangles($arr);
            unset($num);
            unset($ps);
            unset($p0);
            unset($arr);
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setTriangles($arr)
    {
        try {
            $this->triangles= $arr;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getTriangles()
    {
        try {
            if ('Leo\Figure\Triangle' != get_class($this)) {
                if (empty($this->triangles)) {
                    $this->generateTriangles();
                }
            }
            return $this->triangles;
        } catch (\Exception $e) {
            throw $e;
        }
    }

}
```


### 6.Triangle(三角形) {#6-dot-triangle--三角形}

由三个点构成， 提供一个操作来判断点是否在三角形内部

通过该点连接三角形三个顶点，会把原本的三个夹角变成六个夹角，如果六个夹角和等于180°，则在三角形内部

```php
// 矩形类
class Triangle extends ConvexPolygon
{
    private $p1;
    private $p2;
    private $p3;

    public function __construct(Point $p1, Point $p2, Point $p3)
    {
        try {
            $this->setP1($p1);
            $this->setP2($p2);
            $this->setP3($p3);

            $arr = [
                $this->getP1(),
                $this->getP2(),
                $this->getP3()
            ];
            parent::__construct($arr);
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // 判断一个点是否在矩形内
    public function inTriangle(Point $p)
    {
        try {
            $p1 = $this->getP1();
            $p2 = $this->getP2();
            $p3 = $this->getP3();

            $ls = $this->getLines();

            $l1 = new Line($p, $p1);
            $l2 = new Line($p, $p2);
            $l3 = new Line($p, $p3);

            $a1 = (new Angle($l1, $ls[0]))->getAngle();
            $a2 = (new Angle($l2, $ls[1]))->getAngle();
            $a3 = (new Angle($l3, $ls[2]))->getAngle();

            // $t = new Angle($l3, $ls[2]);
            // dump($t);
            // dump($t->getAngle());

            $l1 = new Line($p1, $p);
            $l2 = new Line($p2, $p);
            $l3 = new Line($p3, $p);

            $b1 = (new Angle($ls[2], $l1))->getAngle();
            $b2 = (new Angle($ls[0], $l2))->getAngle();
            $b3 = (new Angle($ls[1], $l3))->getAngle();


            // $as  = $tri->getAngles();
            // foreach ($as as $a) {
            //     dump($a->getAngle());
            // }

            // dump($this);
            // dump("$a1/ $a2/ $a3/ $b1/ $b2/ $b3");
            // die;

            $c = $a1 + $a2 + $a3 + $b1 + $b2 + $b3;


            $is = false;
            if (180 >= (int)$c) {
                $is = true;
            } else {
                $is = false;
            }
            return $is;
        } catch (LineOverlapException $e) {
            return true;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setP1(Point $p1)
    {
        try {
            $this->p1 = $p1;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP1()
    {
        try {
            return $this->p1;
        } catch (\Exception $e) {
            throw $e;
        }
    }

    // setting and  getting
    private function setP2(Point $p2)
    {
        try {
            $this->p2 = $p2;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP2()
    {
        try {
            return $this->p2;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    // setting and  getting
    private function setP3(Point $p3)
    {
        try {
            $this->p3 = $p3;
        } catch (\Exception $e) {
            throw $e;
        }
    }
    public function getP3()
    {
        try {
            return $this->p3;
        } catch (\Exception $e) {
            throw $e;
        }
    }
}
```


## 使用示例 {#使用示例}

```php
$drawing = [
                ['x' => 0, 'y' => 0],
                ['x' => 10, 'y' => 0],
                ['x' => 10, 'y' => 10],
                ['x' => 7, 'y' => 10],
                ['x' => 7, 'y' => 5],
                ['x' => 3, 'y' => 5],
                ['x' => 3, 'y' => 10],
                ['x' => 0, 'y' => 10],
                ['x' => 0, 'y' => 0]
            ];

$p = new Point(5, 10);

$arr_p_pol = [];
for($i = count($drawing)-1; $i > 0;$i--) {
    if ($drawing[$i]['x'] == $drawing[$i-1]['y'] &&
        $drawing[$i]['x'] == $drawing[$i-1]['y']
    ) {
        continue;
    }
    $arr_p_pol[] = new Point($drawing[$i]['x], $drawing[$i]['y']);
}
$pol = new Polygon($arr_p_pol);
$is_1 = $pol->inPolygon($p);
```
