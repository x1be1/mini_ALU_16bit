# mini_ALU_16bit
This a very bad design
1. 这个简单ALU仅是初学者在理论上的实现，使用对应操作码对操作数进行对应的算数或逻辑操作，不具备任何实际使用价值。
This simple ALU is only a theoretical implementation for beginners. It uses corresponding operation codes to perform corresponding arithmetic or logical operations on the operands, and does not have any practical value.
3. 该ALU可进行加减乘除、逻辑操作、移位和比较功能。
The ALU can perform addition, subtraction, multiplication and division, logical operations, shifting and comparison functions.
5. 注意的是除法输出结果需要经过十六个计数周期，所以在波形模拟时最后测试除法，其他操作均在下个时钟上升沿输出。
 Note that the division output result needs to go through sixteen counting cycles,and other operations only require one cycle
7. 各模块并不完美，乘法仅是部分积的全部求和（手算模拟），对除法的理解也不是很深，还有很多需要优化的地方。
Each module is not perfect, multiplication is only the complete sum of partial products (simulated by hand), and my understanding of division is not deep. There are still many areas that need to be optimized.
