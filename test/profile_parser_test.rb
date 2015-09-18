require "minitest/autorun"
require "benchmark"
require_relative '../lib/ez7gen/profile_parser'

class TestProfileParser < MiniTest::Unit::TestCase
	
	def setup
		@parser = ProfileParser.new('2.4', 'ADT_A01')
	end

	def test_init
		assert(@parser !=nil)
		# assert(hl7 != nil)
		# refute_nil(hl7)
	end


	def test_getMessageStructrue
		expected = "MSH~EVN~PID~[~PD1~]~[~{~ROL~}~]~[~{~NK1~}~]~PV1~[~PV2~]~[~{~ROL~}~]~[~{~DB1~}~]~[~{~OBX~}~]~[~{~AL1~}~]~[~{~DG1~}~]~[~DRG~]~[~{~PR1~[~{~ROL~}~]~}~]~[~{~GT1~}~]~[~{~IN1~[~IN2~]~[~{~IN3~}~]~[~{~ROL~}~]~}~]~[~ACC~]~[~UB1~]~[~UB2~]~[~PDA~]"
		assert_equal(expected, @parser.getMessageStructure())
	end

	def test_getSegmentStructure
		al1 =  @parser.getSegmentStructure('[~{~AL1~}~]')
		puts al1
		assert_equal 6, al1.size
		assert_equal('Set ID - AL1', al1.first['description'.to_sym])
	end

   def test_processSegments
   		struct = "MSH~EVN~PID~[~PD1~]~[~{~ROL~}~]~[~{~NK1~}~]~PV1~[~PV2~]~[~{~ROL~}~]~[~{~DB1~}~]~[~{~OBX~}~]~[~{~AL1~}~]~[~{~DG1~}~]~[~DRG~]~[~{~PR1~[~{~ROL~}~]~}~]~[~{~GT1~}~]~[~{~IN1~[~IN2~]~[~{~IN3~}~]~[~{~ROL~}~]~}~]~[~ACC~]~[~UB1~]~[~UB2~]~[~PDA~]"
   		results = @parser.processSegments(struct)
   		assert_equal(2, results.size())
   		assert_equal(21, results[:segments].size())
   		assert_equal('[~PD1~]', results[:segments][0])
   end

   def test_codeTable
   		attributes = @parser.getCodeTable("62")
   		p attributes[0].class
			p attributes.size
   		#p attributes

			# assert_equal(3, attributes.size)
			puts attributes
			assert_equal('1', attributes[0][:position])
			assert_equal('02', attributes[1][:value])
			assert_equal('Census management', attributes[2][:description])
	 end

	def test_codeTable_blank
		attributes = @parser.getCodeTable("")
		p attributes
		print attributes.empty?
	end

   def test_getSegments
			results =  @parser.getSegments
			assert_equal(21, results[:segments].size())
			assert_equal('[~PD1~]', results[:segments][0])
	 end

   def test_getSegments_vaz
		 puts Benchmark.measure("segments"){
		 @parser = ProfileParser.new('vaz2.4', 'ADT_A01')
		 results =  @parser.getSegments
		 puts results
					}
		 # assert_equal(21, results[:@encodedSegments].size())
		 # assert_equal('[~PD1~]', results[:@encodedSegments][0])
	 end

end