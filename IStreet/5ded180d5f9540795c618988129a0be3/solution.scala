object Solution {
  def factorNumber(number: Long):Traversable[Long] = {
    def factorNumberHelper(num: Long, accumFactors: List[Long]):Traversable[Long] = num match {
      case 1 => accumFactors
      case _ => 
        lazy val range = Stream.range(2,math.ceil(math.sqrt(num)).toLong + 1)
        val foundFactor:Option[Long] = range.find(int => num%int == 0)
        val curFactor:Long = foundFactor.getOrElse(num)
        factorNumberHelper(num/curFactor, List(curFactor) ++ accumFactors)
    }
    factorNumberHelper(number, List())
  }
    
  def factorHistogram(number: Long):Map[Long,Int] = {
    factorNumber(number).foldLeft[Map[Long, Int]](Map.empty)((hist, fac) => hist + (fac -> (hist.getOrElse(fac, 0) + 1)))
  }
    
  def pureFactors(histogram: Map[Long,Int]):Iterable[Seq[Long]] = {
    for((key,value) <- histogram) yield (for(exp <- 0 until value+1) yield math.pow(key, exp).toLong)
  }
    
  def multiplyFactors(pureFactors: Iterable[Seq[Long]]):Seq[Long] = pureFactors match{
    case Seq() => Seq(1)
    case _ => for(curFact <- pureFactors.head; futureFact <- multiplyFactors(pureFactors.tail)) yield curFact*futureFact
  }
    
  def allFactors(number: Long):Set[Long] = {
    multiplyFactors(pureFactors(factorHistogram(number))).toSet
  }

  def gcd(number1: Long, number2: Long):Long = (number1, number2) match {
    case (a, 0) => a
    case (0, b) => b
    case _ =>
      val small:Long = math.min(number1, number2)
      val big:Long = math.max(number1, number2)
      val mult:Long = big/small
      gcd(small, big - mult*small)
  }

  def solveTestcase(friendly: Long, unfriendlyNums: Array[Long]):Long = {
    var friendlyFactors:Set[Long] = allFactors(friendly)
    val commonFactors:Set[Long] = unfriendlyNums.map(gcd(friendly,_)).toSet
    commonFactors.foreach(ele => if(friendlyFactors.contains(ele)) friendlyFactors -= ele)
    friendlyFactors.size
  }

  def lineToIntArray():Array[Long] = readLine().split(" ").map(_.toLong)

  def main(args: Array[String]) {
    val ints:Array[Long] = lineToIntArray()
    val friendly:Long = ints(1)
    val unfriendlyNumbers = lineToIntArray()
    println(solveTestcase(friendly, unfriendlyNumbers))
  }
}
