#import "../lib.typ": set_style

#import "@preview/subpar:0.2.0"

/// 文章标题等基本数据
#let title_chs = "基于卷积神经网络的四位数字验证码识别方法"
#let abstract_chs = "本研究基于CNN神经网络网络技术，对四位数字验证码进行识别。首先，本研究通过一个验证码接口，收集了需要识别的验证码，并对其进行了分割，获得需要识别的数字训练集。之后，本研究基于Tensorflow和Keras框架，设计了10层神经学习网络，用于训练数据集。最后，基于实时验证码数据，使用模型验证，从而体现了本数据集在该问题上的适用性。"
#let keyword_chs = "CNN 神经网络；验证码识别"
#let author_chs = (
  (name: "昂内塔·费尔特斯科格", insitute: "北极唱片公司 签约歌手，瑞典 斯德哥尔摩 64693"),
  (name: "比约恩·奥瓦尔斯", insitute: "北极唱片公司 录音棚工人，瑞典 斯德哥尔摩 64693"),
  (name: "班尼·安德森", insitute: "北极唱片公司 录音棚工人，瑞典 斯德哥尔摩 64693"),
  (name: "安妮-弗瑞德·林斯塔德", insitute: "北极唱片公司 签约歌手，瑞典 斯德哥尔摩 64693"),
)

#let title_eng = "Four-digit CAPTCHA Recognition Method Based on Convolutional Neural Networks"
#let abstract_eng = "This study is based on the CNN neural network network technique to recognize the four-digit CAPTCHA. Firstly, this study collects the CAPTCHA to be recognized through a CAPTCHA interface and segments it to obtain the training set of numbers to be recognized. After that, this study designed a 10-layer neural learning network based on Tensorflow and Keras framework for training the dataset. Finally, based on real-time CAPTCHA data, the model was used for validation, thus demonstrating the applicability of this dataset to the problem."
#let keyword_eng = "CNN; CAPTCHA"
#let author_eng = (
  (name: "Agnetha Fältskog", insitute: "Contracted singer, Polar Music, Stockholm, Sweden 64693"),
  (name: "Björn Ulvaeus", insitute: "Studio worker, Polar Music, Stockholm, Sweden 64693"),
  (name: "Benny Andersson", insitute: "Studio worker, Polar Music, Stockholm, Sweden 64693"),
  (name: "Anni-Frid Lyngstad", insitute: "Contracted singer, Polar Music, Stockholm, Sweden 64693"),
)

// 引用格式文件
#show: doc => set_style(
  title_chs,
  author_chs,
  abstract_chs,
  keyword_chs,
  title_eng,
  author_eng,
  abstract_eng,
  keyword_eng,
  doc,
  bibliography.with("./ref.bib")
)

// 开始正文编写

在生活实际中，用户通常在输入用户密码后，需要输入数字验证码。该验证码是以四位阿拉伯数字为主，辅以若干噪点和线条作为干扰形成的图片。验证码如果使用传统OCR识别，这些噪点和线条会干扰识别过程，从而对识别结果造成严重影响。因此，本研究欲使用机器学习技术，生成用于识别数字验证码的模型。对数据集进行训练后，生成的模型能够有较高的识别正确率。

本研究主要对若干验证码图片进行研究。这些验证码图片由四位阿拉伯数字字符构成，辅以若干噪点和线条作为干扰。本研究的核心是对验证码上数字进行分类识别，从而能从验证码图片里提取出四位阿拉伯数字字符信息。提取的识别准确率需要到 85% 左右，同时不到达过拟合程度。

= 数据集的处理

本研究将从西电缴费系统的验证码接口中获取训练数据，其中一次获取到的数据如@fig:dataset-example 所示。该图的长度为200个像素，高度为80个像素，四个数字大致均匀地在水平面上一字排开。

#figure(
  image("img/dataset-example.png"),
  caption: [数据集示例],
) <dataset-example>

由于本质上是对验证码数字进行特征识别，故需要对图片进行分割，从而获得单个数字字符。本研究根据数字排列特性，将图片水平四等分，每一个部分是一个数字字符。这些数字字符即本次训练需要用到的训练集。@fig:dataset-example 经过分离后的四个图片如@fig:dataset-split 所示。

#figure(
  stack(
    dir: ltr,
    spacing: 5mm,
    image("img/6.1734793280.0.jpg", width: 15%),
    image("img/2.1734793280.1.jpg", width: 15%),
    image("img/7.1734793280.2.jpg", width: 15%),
    image("img/1.1734793280.3.jpg", width: 15%),
  ),
  caption: [分割后数据集示例],
) <dataset-split>

获取数据的代码在`dataset.py`里，该段代码将从验证码接口获取图片，然后在用户输入该验证码代表数字后，将图片分割以获得数据集。经过对327张图片的处理，本研究所使用的数据集有1308张数字字符图片。图像的对比度相当高，所以无需进行二值化以及黑白化处理。部分数据集如@fig:dataset 所示。

#figure(
  image("img/dataset.png"),
  caption: [数据集示例],
) <dataset>

= 神经网络的设计

== 概述

参考#cite(<XDXK202413014>,form: "prose")的论文，本研究中用于训练的神经网络有10层，其中包括三层卷积层、三层最大池层、两个全连接层、一个降维层和一个随机舍弃层构成。训练集在经过卷积层和最大池层后，通过降维层来将其降维到一维。在此之后，经过全连接层和随机舍弃部分神经元后，形成了最终训练模型。具体各层的参数如@tbl:network-table 所示。

#figure(
  table(
    columns: 5,
    align: center + horizon,
    stroke: none,
    table.hline(),
    table.header([*名称*],[*输入大小*],[*输出大小*],[*参数*],[*注释*],),
    table.hline(stroke: .5pt),
    [卷积层0],[(80,50,1)],[(78,48,16)],[160],[激活函数 ReLU],
    [最大池层0],[(78,48,16)],[(39,24,16)],[0],[池大小(2,2)],
    [卷积层1],[(39,24,16)],[(37,22,32)],[4640],[激活函数 ReLU],
    [最大池层1],[(37,22,32)],[(18,11,32)],[0],[池大小(2,2)],
    [卷积层2],[(18,11,32)],[(16,9,32)],[9248],[激活函数 ReLU],
    [最大池层2],[(16,9,32)],[(4,2,32)],[0],[池大小(2,2)],
    [降低维度层],[(4,2,32)],[256],[0],[-],
    [全连接层0],[256],[64],[16448],[激活函数 ReLU],
    [随机舍弃层],[64],[64],[0],[舍弃概率 30%],
    [全连接层1],[64],[9],[585],[激活函数 softmax],
    table.hline(),
  ), 
  caption: [神经网络设计],
) <network-table>

接下来介绍这些层的基本定义和用途。

== 卷积层

卷积操作的目的是在保留数据整体特征的基础上，减小数据的大小，从而减少计算量，加速训练过程。同时，卷积操作也能对图像的边缘，纹理特征进行进行提取，从而获得特征图。卷积层参数包括卷积核的大小、步长、填充，以及激活函数。该操作将输入特征图的每个局部区域和卷积核相乘，获得一个输出值。在输出值的基础上，应用激活函数以引入非线性特性，由此获得最终的特征图。

== 池化层

池化过程能够减小卷积神经网络或其他类型神经网络的特征图尺寸，从而减少计算量、降低模型复杂性并提高模型的鲁棒性。该操作将输入特征图的每个局部区域映射到一个输出值，这个输出值可以是局部区域中的最大值(最大池化)或平均值(平均池化)。池化操作通常包括两个主要参数：池化窗口大小和步幅。

本次训练使用最大池，即提取池化窗口中的最大值，从而形成池化特征图，输出到下一层。该过程如图@fig:max-polling 所示。

#figure(
  image("img/max_polling.jpg"),
  caption: [最大池示意],
)<max-polling>

== 全连接层、降低维度层和随机舍弃层

全连接层位于卷积神经网络隐含层的最后部分，并只向其它全连接层传递信号。特征图在全连接层中会失去空间拓扑结构，被展开为向量。该层用于对数据进行分类，将学到的特征表示映射到样本标记空间。该步骤也可引入激活函数来引入非线性特性。

由于全连接层只接受一维数据，而在卷积和池化后的数据有三维，在这两层之间需要通过降低维度层来将数据降低到一维。

为减少神经网络的过拟合现象，训练过程中可以通过对部分神经元进行舍弃，从而使得最终训练模型不过多拟合原先训练集。这个过程是在随机舍弃层（即Dropout层）里实现的。

== 激活函数

本次训练用到的神经元使用了两个激活函数，ReLU激活函数和Softmax激活函数。

ReLU激活函数@Glorot2011DeepSR 定义如@eqt:1 所示。

$ f(x) = max(0,x) $<1>

即如果输入小于 0 则输出 0，否则输出输入值。

Softmax激活函数@goodfellow2016deep 定义如@eqt:2 所示。

$ f(x) = e^x / (sum_j e^j) $<2>

即该元素指数与所有元素指数和的比值。

= 训练过程

训练环境如@tbl:env 所示。

#figure(
  table(
    columns: 2,
    align: center,
    stroke: none,
    table.hline(),
    [类型],[型号],
    table.hline(stroke: 0.5pt),
    [CPU],[AMD Ryzen 7 PRO 4750U],
    [GPU],[无],
    [操作系统],[AOSC OS 12.0.1],
    [Conda-Forge 版本],[24.11.2],
    [Python 版本],[3.12],
    [Tensorflow 版本],[2.18.0],
    [Keras 版本],[3.6.0],
    table.hline(),
  ),
  caption: [训练环境],
)<env>

在训练之前，将数据集进行分类，保留20%作为测试用例。在此之后，对模型进行100次训练。训练结果保存为 tflite 模型文件，如@fig:model-result 所示。在本次训练中，总计训练耗费时间为118秒，最终训练出125KB的模型文件。

#figure(
  stack(
    dir: ttb,
    spacing: 5mm,
    image("img/time.png"),
    image("img/file.png"),
  ),
  caption: [训练时间和成果],
) <model-result>

在训练过程中，本研究发现在17次训练时候，正确率已经到达了90%左右，这说明本模型收敛得很快，也说明本神经网络能够高效地训练本模型。

#figure(
  image("img/accuracy_log.png"),
  caption: [训练时日志],
) <accuracy_log>

#figure(
  image("img/accuracy.png", width: 70%),
  caption: [训练收敛示意],
) <accuracy>

= 评估模型

评估模型代码复用制作数据集里获取数据代码和窗口代码，当获取到数据后，直接使用模型进行预测，输出结果后由测试者进行判断。部分代码和一次测试结果如@fig:correct 所示。

本次测试，共进行输出结果判断一百次，结果有六次错误，正确率为96%。结合以往类似模型在识别中的正确率，本研究认为该正确率能够反映出该模型对验证码的识别正确率。同时，该正确率也超过了85%的目标。

#figure(
  image("img/correct.png"),
  caption: [部分代码和测试结果],
) <correct>

@fig:wrong-data 显示了四次错误识别，这些错误大多和大角度倾斜数字字符相关。大多数情况是1字符被放倒，从而被误解为比较类似的7或者4。由于这些字符在外观方面比较相似，出现这种情况很难避免。

另外，以@fig:wrong-data-c 为例子，由于2字符倾斜过于大，跨越了四分之一分界线和二分之一分界线，同时左侧还与第一个字符相粘连，进而在识别方面出现错误。这体现出在做数据预处理方面有不完善之处，由于分割数字时候过于机器化，没有对小部分数字缺失情况进行处理。导致训练时候出现了问题。

#let width_wrong_data = 70%
#subpar.grid(
  figure(image("img/1-4.png", width: width_wrong_data), caption: [1误识别为4]), <wrong-data-a>,
  figure(image("img/1-7.png", width: width_wrong_data), caption: [1误识别为7]), <wrong-data-b>,
  figure(image("img/2-8.png", width: width_wrong_data), caption: [2误识别为8]), <wrong-data-c>,
  figure(image("img/7-1.png", width: width_wrong_data), caption: [7误识别为1]), <wrong-data-d>,
  columns: (1fr, 1fr),
  caption: [四次错误识别],
  label: <wrong-data>,
)

不过瑕不掩瑜，96%的识别正确率已经足够将其应用于生产环境。如果识别验证码只能有三次机会，则最终失败概率为0.0064%，基本可以忽略不计，可以认为能够快速地自动识别验证码。

= 总结

通过本次研究，我们进一步了解了神经网络学习的含义，对课本上的定义有了更深的了解。在构建神经网络的过程中，我对卷积、最大池等在图像分类中的作用有了更深的认识。

同时，训练出来的模型能够解决实际问题。该模型是基于学习缴费系统验证码而训练的，在合适的时候，该系统能够辅助完成电费查询的自动化，从而能够提醒缴纳电费。
