package godiacritics

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestRemoval(t *testing.T) {
	cases := []struct {
		input    string
		expected string
	}{
		{input: "a", expected: "a"},
		{input: "ä", expected: "a"},
		{input: "Ä", expected: "A"},
		{input: "ß", expected: "ss"},
		{input: "Č", expected: "C"},
		{input: "Ł", expected: "L"},
		{input: "Ä möre ȼꝋmpleᶍ ⱸxamplé", expected: "A more complex example"},
	}

	for _, c := range cases {
		t.Run(c.input, func(t *testing.T) {
			actual := Normalize(c.input)
			assert.Equal(t, c.expected, actual)
		})
	}
}
